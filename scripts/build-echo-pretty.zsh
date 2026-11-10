#!/usr/bin/env -S zsh -euo pipefail
# shellcheck shell=bash # trick shellcheck into working with zsh
# shellcheck disable=SC2296 # Falsely identifies zsh expansions
#
# ---- ---- ----  About this Script  ---- ---- ----
#
# Purpose: Build a release echo_pretty binary (arm64 by default). Optionally also
#          build x86_64 + a lipo-merged universal binary, and optionally install it.
# Usage:   ./scripts/build-echo-pretty.zsh [--universal] [--output-dir <dir>] [--install] [--install-dir <dir>]
#          ./scripts/build-echo-pretty.zsh --help
#
# Needs only zsh, the Swift toolchain (`swift`) and `lipo` (Xcode command line tools).
#

# ---- ---- ----     Logging     ---- ---- ----

# Colors only when stderr is a terminal and NO_COLOR isn't set (https://no-color.org).
if [[ -t 2 && -z "${NO_COLOR:-}" && "${TERM:-}" != dumb ]]; then
  typeset -r c_bold=$'\e[1m' c_code=$'\e[96m' c_faint=$'\e[2m' c_ok=$'\e[32m' c_err=$'\e[31m' c_warn=$'\e[33m' c_reset=$'\e[0m'
else
  typeset -r c_bold="" c_code="" c_faint="" c_ok="" c_err="" c_warn="" c_reset=""
fi

typeset is_debug=""

# Status lines go to stderr; stdout stays free for the binary paths.
function log_step    { print -u2 -r -- "${c_bold}==>${c_reset} $*" }
function log_success { print -u2 -r -- "${c_ok}[OK]${c_reset} $*" }
function log_warning { print -u2 -r -- "${c_warn}[WARNING]${c_reset} $*" }
function log_error   { print -u2 -r -- "${c_err}[ERROR]${c_reset} $*" }
function log_debug   { [[ -n "$is_debug" ]] && print -u2 -r -- "${c_faint}[DEBUG] $*${c_reset}"; return 0 }

# ---- ---- ----     Usage     ---- ---- ----

# Captured at root scope: inside a function, $0 is the function name.
typeset -r script_name="${0:A:t}"
typeset -r default_install_dir="$HOME/.local/bin"

function print_usage {
  print -r -- "${c_bold}SYNOPSIS${c_reset}
  ${c_code}${script_name} [--universal] [--output-dir <dir>] [--install] [--install-dir <dir>] [-d|--debug]${c_reset}

${c_bold}DESCRIPTION${c_reset}
  Build a release echo_pretty binary. arm64 only by default; --universal also builds x86_64 and
  merges both into a universal binary.

${c_bold}OPTIONS${c_reset}
  ${c_code}--universal${c_reset}
      Also build x86_64 and lipo-merge a universal binary (default: arm64 only)
  ${c_code}--output-dir <dir>${c_reset}
      Root dir for build output (default: <repo>/.gitignored/release)
  ${c_code}--install${c_reset}
      Copy the built binary (universal if --universal, else arm64) into the install dir
  ${c_code}--install-dir <dir>${c_reset}
      Install dir; implies --install (default: ${default_install_dir})
  ${c_code}--help${c_reset}
      Show this help message and exit

${c_bold}DEVELOPMENT OPTIONS${c_reset}
  ${c_code}-d, --debug${c_reset}
      Print debug output

${c_bold}OUTPUT${c_reset}
  Binaries are written to ${c_code}<output-dir>/{arm64,x86_64,universal}/echo_pretty${c_reset}

${c_bold}EXAMPLES${c_reset}
  Build arm64 only:
    ${c_code}./scripts/${script_name}${c_reset}
  Build universal and install to ${default_install_dir}:
    ${c_code}./scripts/${script_name} --universal --install${c_reset}"
}

# ---- ---- ----   Argument Parsing   ---- ---- ----

# -D: remove parsed options from $@
# -F: fail on unknown options
# See: `man zshmodules` (zparseopts)
zparseopts -D -F -- \
  -output-dir:=opt_output_dir \
  -universal=flag_universal \
  -install=flag_install \
  -install-dir:=opt_install_dir \
  d=flag_debug -debug=flag_debug \
  -help=flag_help || {
    print_usage >&2
    exit 2
  }

if (( ${#flag_help} )); then
  print_usage
  exit 0
fi

is_debug="${flag_debug:+true}"

typeset -r product="echo_pretty"
typeset -r repo_dir="${0:A:h:h}"
typeset -r output_dir="${opt_output_dir[-1]:-${repo_dir}/.gitignored/release}"
typeset -r is_universal="${flag_universal:+true}"
# --install-dir implies --install
typeset -r is_install="${${flag_install:-${opt_install_dir:-}}:+true}"
typeset -r install_dir="${opt_install_dir[-1]:-$default_install_dir}"
typeset -r arm_dir="${output_dir}/arm64"
typeset -r x86_dir="${output_dir}/x86_64"
typeset -r universal_dir="${output_dir}/universal"

log_debug "repo_dir=${repo_dir}"
log_debug "output_dir=${output_dir}"
log_debug "is_universal=${is_universal} is_install=${is_install} install_dir=${install_dir}"

# ---- ---- ----     Functions     ---- ---- ----

# Builds `$product` in release for one architecture and copies the binary to `$output_dir/<arch>/`.
#   build_for_arch <arch>    # arm64 or x86_64
# Exit status: 0 on success, else the failing command's.
function build_for_arch {
  local -r arch="$1"
  local -r arch_dir="${output_dir}/${arch}"
  local -r -a build_cmd=(swift build --package-path "$repo_dir" --product "$product" --configuration release --arch "$arch")

  log_step "build ${product} release for ${arch}: ${c_code}${(j: :)${(@q-)build_cmd}}${c_reset}"
  local build_output=""
  build_output="$("${build_cmd[@]}" 2>&1)" || {
    local -i exit_code=$?
    print -u2 -r -- "$build_output"
    log_error "build ${product} release for ${arch} failed (exit ${exit_code})"
    return $exit_code
  }
  log_debug "$build_output"

  # Ask SwiftPM for the bin path rather than hard-coding `.build/<arch>-apple-macosx/release`: the
  # Swift Build backend (Swift 6.4+) writes every arch to the same `.build/out/Products/Release`
  # dir, which is why each arch's binary is copied out right after it is built.
  local bin_path=""
  bin_path="$("${build_cmd[@]}" --show-bin-path 2>/dev/null | tail -n 1)" || {
    local -i exit_code=$?
    log_error "locate the ${arch} binary failed (exit ${exit_code})"
    return $exit_code
  }
  local -r built_binary="${bin_path}/${product}"
  log_debug "built_binary=${built_binary}"

  mkdir -p "$arch_dir"
  cp "$built_binary" "${arch_dir}/${product}" || {
    local -i exit_code=$?
    log_error "copy the ${arch} binary to ${arch_dir} failed (exit ${exit_code})"
    return $exit_code
  }
  log_success "built ${arch_dir}/${product}"
}

# ---- ---- ----     Script Work     ---- ---- ----

build_for_arch arm64 || exit $?

if [[ -n "$is_universal" ]]; then
  build_for_arch x86_64 || exit $?

  log_step "create universal binary"
  mkdir -p "$universal_dir"
  lipo -create -output "${universal_dir}/${product}" "${x86_dir}/${product}" "${arm_dir}/${product}" || {
    typeset -i exit_code=$?
    log_error "lipo failed (exit ${exit_code})"
    exit $exit_code
  }
  log_success "built ${universal_dir}/${product}"
else
  log_debug "skipping x86_64 and universal binaries (pass --universal to opt in)"
fi

# Report: one binary path per line on stdout, its architectures on stderr
typeset -a report_dirs=("$arm_dir")
[[ -n "$is_universal" ]] && report_dirs+=("$x86_dir" "$universal_dir")
typeset dir binary file_info
for dir in "${report_dirs[@]}"; do
  binary="${dir}/${product}"
  [[ -f "$binary" ]] || continue
  file_info="$(lipo -info "$binary" 2>/dev/null)"
  print -r -- "$binary"
  print -u2 -r -- "    ${c_faint}${file_info##*: }${c_reset}"
done

# Install (opt-in)
if [[ -n "$is_install" ]]; then
  typeset install_source="${arm_dir}/${product}"
  [[ -n "$is_universal" ]] && install_source="${universal_dir}/${product}"

  log_step "install ${product} to ${install_dir}"
  mkdir -p "$install_dir" && cp "$install_source" "${install_dir}/${product}" && chmod +x "${install_dir}/${product}" || {
    typeset -i exit_code=$?
    log_error "install to ${install_dir} failed (exit ${exit_code})"
    exit $exit_code
  }
  log_success "installed ${install_dir}/${product}"

  # Compare absolute paths so `~`, symlinks and trailing slashes don't matter.
  typeset -r -a abs_path_dirs=("${(@)path:A}")
  if (( ! ${abs_path_dirs[(Ie)${install_dir:A}]} )); then
    log_warning "${install_dir} is not on PATH. Add it to your shell config: ${c_code}export PATH=\"${install_dir}:\$PATH\"${c_reset}"
  fi
fi
