#!/usr/bin/env -S zsh -euo pipefail
# shellcheck shell=bash # trick shellcheck into working with zsh
# shellcheck disable=SC2296 # Falsely identifies zsh expansions
# shellcheck disable=SC1091 # Complains about sourcing without literal path
#
# ---- ---- ----  About this Script  ---- ---- ----
#
# Purpose: Build a release echo_pretty binary (arm64 by default). Optionally also
#          build x86_64 + a lipo-merged universal binary, and optionally install it.
# Author:  zakkhoyt
# Usage:   ./scripts/build-echo-pretty.zsh [--universal] [--output-dir <dir>] [--install] [--install-dir <dir>]
#
# echo_pretty was relocated here from HatchTerminal on 2026-10-28
# (branch zakk/echo_pretty/relocate_to_vwwutility).
#

# ---- ---- ----     Source Utilities     ---- ---- ----

# Sourced without "$0" "$@" on purpose: boilerplate must strip common flags (--help, --debug, ...)
# from this script's $@ so the script-specific `zparseopts -F` below doesn't reject them.
source "$HOME/.zsh_home/utilities/.zsh_boilerplate"

# ---- ---- ----     Usage     ---- ---- ----

# Captured at root scope: inside a function, $0 is the function name.
typeset -r script_name="${0:A:t}"
slog_var1_se_d "script_name"

function print_usage {
  local -r i2="${INDENT_2:-  }"
  local -r i4="${INDENT_4:-    }"
  local -r i6="${i2}${i4}"

  slog_se --bold "SYNOPSIS" --default
  slog_se
  slog_se "${i2}" --code "${script_name} [--universal] [--output-dir <dir>] [--install] [--install-dir <dir>] [DEVELOPMENT OPTIONS]" --default
  slog_se

  slog_se --bold "OPTIONS" --default
  slog_se
  # Option names are embedded in an indented string on purpose: echo_pretty treats separate args that
  # begin with `--` (EX: --code '--help') as its own flags and drops them.
  slog_se "${i2}" --bold --italic "SCRIPT OPTIONS" --default
  slog_se --bold "${i4}--universal" --default
  slog_se "${i6}Also build x86_64 and lipo-merge a universal binary (optional, default: arm64 only)"
  slog_se --bold "${i4}--output-dir <dir>" --default
  slog_se "${i6}Root dir for build output (optional, default: <repo>/.gitignored/release)"
  slog_se --bold "${i4}--install" --default
  slog_se "${i6}Copy the built binary (universal if --universal, else arm64) into the install dir (optional)"
  slog_se --bold "${i4}--install-dir <dir>" --default
  slog_se "${i6}Install dir, implies --install (optional, default: \$HOME/.zsh_home/bin)"
  slog_se
  slog_se "${i2}" --bold --italic "META-OPTIONS" --default
  slog_se --bold "${i4}--help" --default
  slog_se "${i6}Display this help message and exit"
  slog_se

  slog_se --bold "DEVELOPMENT OPTIONS" --default
  slog_se
  slog_se --bold "${i4}-d, --debug" --default
  slog_se "${i6}Enable debug output"
  slog_se

  slog_se --bold "OUTPUT" --default
  slog_se
  slog_se "${i2}Binaries are written to " --url "<output-dir>/{arm64,x86_64,universal}/echo_pretty" --default
  slog_se

  slog_se --bold "EXAMPLES" --default
  slog_se
  slog_se "${i2}${SYMBOL_BULLET:-•} Build arm64 only"
  slog_se "${i4}" --code "./scripts/${script_name}" --default
  slog_se
  slog_se "${i2}${SYMBOL_BULLET:-•} Build universal and install to \$HOME/.zsh_home/bin"
  slog_se "${i4}" --code "./scripts/${script_name} --universal --install" --default
  slog_se

  return 1
}

if [[ -n "${flag_help:-}" ]]; then
  print_usage || true
  exit 0
fi

# ---- ---- ----   Argument Parsing   ---- ---- ----

zparseopts -D -F -- \
  -output-dir:=opt_output_dir \
  -universal=flag_universal \
  -install=flag_install \
  -install-dir:=opt_install_dir

typeset -r product="echo_pretty"
slog_var1_se_d "product"

typeset -r repo_dir="${0:A:h:h}"
slog_var1_se_d "repo_dir"

typeset -r output_dir="${opt_output_dir[-1]:-${repo_dir}/.gitignored/release}"
slog_var1_se_d "output_dir"

typeset -r is_universal="${flag_universal:+true}"
slog_var1_se_d "is_universal"

# --install-dir implies --install
typeset -r is_install="${${flag_install:-${opt_install_dir:-}}:+true}"
slog_var1_se_d "is_install"

typeset -r install_dir="${opt_install_dir[-1]:-$HOME/.zsh_home/bin}"
slog_var1_se_d "install_dir"

typeset -r arm_dir="${output_dir}/arm64"
slog_var1_se_d "arm_dir"

typeset -r x86_dir="${output_dir}/x86_64"
slog_var1_se_d "x86_dir"

typeset -r universal_dir="${output_dir}/universal"
slog_var1_se_d "universal_dir"

# ---- ---- ----     Functions     ---- ---- ----

# Builds `$product` in release for one architecture and copies the binary to `$output_dir/<arch>/`.
# # SYNOPSIS
# ```zsh
# build_for_arch --arch <arch>
# ```
# # ARGS
# * `--arch <arch>` - Architecture to build. EX: `arm64`, `x86_64`
# # EXIT STATUS
# * `0` - Success
# * non-zero - `swift build` or `cp` failed (exit code is passed through)
# # STDOUT
# None
# # STDERR
# * Build output when the build fails
# * Debug logs when `--debug` is set
function build_for_arch {
  zparseopts -D -F -- \
    -arch:=opt_arch

  local -r arch="${opt_arch[-1]}"
  slog_var1_se_d "arch"

  local -r arch_dir="${output_dir}/${arch}"
  slog_var1_se_d "arch_dir"

  local -r build_cmd="swift build --package-path ${(qqq)repo_dir} --product ${product} --configuration release --arch ${arch}"
  slog_var1_se_d "build_cmd"

  local -r bin_path_cmd="${build_cmd} --show-bin-path"
  slog_var1_se_d "bin_path_cmd"

  # [step] Build release binary
  slog_step_se_d --context will "build ${product} release for ${arch}: " --code "$build_cmd" --default

  local build_output=""
  build_output="$(eval "$build_cmd" 2>&1)" || {
    local -i exit_code=$?
    slog_se "$build_output"
    slog_step_se --context fatal --exit-code "$exit_code" "build ${product} release for ${arch}: " --code "$build_cmd" --default
    return $exit_code
  }
  slog_var1_se_d "build_output"
  slog_step_se_d --context success "built ${product} release for ${arch}"

  # [step] Locate the built binary. Ask SwiftPM rather than hard-coding `.build/<arch>-apple-macosx/release`:
  # the Swift Build backend (Swift 6.4+) writes every arch to the same `.build/out/Products/Release` dir,
  # which is why each arch's binary is copied out right after it is built.
  slog_step_se_d --context will "locate ${arch} binary: " --code "$bin_path_cmd" --default

  local bin_path=""
  bin_path="$(eval "$bin_path_cmd" 2>/dev/null | tail -n 1)" || {
    local -i exit_code=$?
    slog_step_se --context fatal --exit-code "$exit_code" "locate ${arch} binary: " --code "$bin_path_cmd" --default
    return $exit_code
  }
  local -r built_binary="${bin_path}/${product}"
  slog_var1_se_d "built_binary"
  slog_step_se_d --context success "located ${arch} binary: " --url "$built_binary" --default

  # [step] Copy binary to output dir
  slog_step_se_d --context will "copy ${arch} binary to " --url "$arch_dir" --default

  mkdir -p "$arch_dir"
  cp "$built_binary" "${arch_dir}/${product}" || {
    local -i exit_code=$?
    slog_step_se --context fatal --exit-code "$exit_code" "copy ${arch} binary to " --url "$arch_dir" --default
    return $exit_code
  }

  slog_step_se_d --context success "copied ${arch} binary to " --url "$arch_dir" --default
  return 0
}

# ---- ---- ----     Script Work     ---- ---- ----

build_for_arch --arch "arm64" || exit $?

if [[ -n "$is_universal" ]]; then
  build_for_arch --arch "x86_64" || exit $?

  # [step] lipo universal binary
  typeset -r lipo_cmd="lipo -create -output ${(qqq)universal_dir}/${product} ${(qqq)x86_dir}/${product} ${(qqq)arm_dir}/${product}"
  slog_var1_se_d "lipo_cmd"
  slog_step_se_d --context will "create universal binary: " --code "$lipo_cmd" --default

  mkdir -p "$universal_dir"
  eval "$lipo_cmd" || {
    typeset -i exit_code=$?
    slog_step_se --context fatal --exit-code "$exit_code" "create universal binary: " --code "$lipo_cmd" --default
    exit $exit_code
  }

  slog_step_se_d --context success "created universal binary"
else
  slog_step_se_d --context info "skipping x86_64 and universal binaries (pass " --code "--universal" --default " to opt in)"
fi

# [step] Report output
slog_step_se --context finished "${product} release binaries written to " --url "$output_dir" --default

typeset -a report_dirs=("$arm_dir")
[[ -n "$is_universal" ]] && report_dirs+=("$x86_dir" "$universal_dir")
slog_var1_se_d "report_dirs"

for ((i=1; i<=${#report_dirs[@]}; i++)); do
  typeset binary="${report_dirs[$i]}/${product}"
  [[ -f "$binary" ]] || continue
  typeset file_info="$(lipo -info "$binary" 2>/dev/null)"
  slog_se "  " --url "$binary" --default "
    ${file_info##*: }"
done

# [step] Install (opt-in)
if [[ -n "$is_install" ]]; then
  typeset install_source="${arm_dir}/${product}"
  [[ -n "$is_universal" ]] && install_source="${universal_dir}/${product}"
  slog_var1_se_d "install_source"

  if [[ ! -d "$install_dir" ]]; then
    slog_step_se_d --context will "create install dir " --url "$install_dir" --default
    mkdir -p "$install_dir" || {
      typeset -i exit_code=$?
      slog_step_se --context fatal --exit-code "$exit_code" "create install dir " --url "$install_dir" --default
      exit $exit_code
    }
    slog_step_se --context did "create install dir " --url "$install_dir" --default
  fi

  slog_step_se_d --context will "install ${product} to " --url "$install_dir" --default

  cp "$install_source" "${install_dir}/${product}" || {
    typeset -i exit_code=$?
    slog_step_se --context fatal --exit-code "$exit_code" "install ${product} to " --url "$install_dir" --default
    exit $exit_code
  }
  chmod +x "${install_dir}/${product}"

  slog_step_se --context success "installed ${product} to " --url "${install_dir}/${product}" --default

  # Warn if install_dir is not on PATH (compare absolute paths so `~`, symlinks, and trailing slashes don't matter)
  typeset -r -a abs_path_dirs=("${(@)path:A}")
  if (( ! ${abs_path_dirs[(Ie)${install_dir:A}]} )); then
    # slog_warning_se (deprecated in favor of `slog_step_se --context warning`) used on purpose: explicitly requested.
    slog_warning_se --url "$install_dir" --default " is not in PATH. Add it to your shell config: " --code "export PATH=\"${install_dir}:\$PATH\"" --default
  fi
fi
