#!/usr/bin/env -S zsh -euo pipefail
# shellcheck shell=bash
# shellcheck disable=SC2296
# shellcheck disable=SC1091
#
# ---- ---- ----  About this Script  ---- ---- ----
#
# Purpose: Build release binaries of zbterms for x86_64 and arm64,
#          then lipo-merge them into a universal binary.
# Author:  zakkhoyt
# Usage:   ./scripts/build-zbterms.zsh [--output-dir <dir>] [--skip-universal]
#

# ---- ---- ----     Source Utilities     ---- ---- ----

source "$HOME/.zsh_home/utilities/.zsh_boilerplate"

# ---- ---- ----   Argument Parsing   ---- ---- ----

zparseopts -D -F -- \
    -output-dir:=opt_output_dir \
    -skip-universal=flag_skip_universal

typeset -r output_dir="${opt_output_dir[-1]:-${0:A:h}/../.gitignored/release}"
slog_var1_se_d "output_dir"

typeset -r skip_universal="${flag_skip_universal:-}"
slog_var1_se_d "skip_universal"

# ---- ---- ----     Script Work     ---- ---- ----

typeset -r repo_dir="${0:A:h}/.."
slog_var1_se_d "repo_dir"

typeset -r x86_dir="${output_dir}/x86_64"
typeset -r arm_dir="${output_dir}/arm64"
typeset -r universal_dir="${output_dir}/universal"
slog_var1_se_d "x86_dir"
slog_var1_se_d "arm_dir"
slog_var1_se_d "universal_dir"

# [step] Create output directories
slog_step_se_d --context will "create output directories"

mkdir -p "$x86_dir" "$arm_dir"
[[ -z "$skip_universal" ]] && mkdir -p "$universal_dir"

slog_step_se_d --context success "created output directories"

# [step] Build x86_64 release binary
slog_step_se_d --context will "build zbterms release for x86_64"

typeset -r x86_cmd="swift build --package-path ${(qqq)repo_dir} --product zbterms --configuration release --arch x86_64"
slog_var1_se_d "x86_cmd"

typeset x86_build_output=""
x86_build_output="$(eval "$x86_cmd" 2>&1)" || {
    typeset -i exit_code=$?
    slog_step_se --context fatal --exit-code "$exit_code" "build zbterms release for x86_64"
    exit $exit_code
}
slog_var1_se_d "x86_build_output"
slog_step_se_d --context success "built zbterms release for x86_64"

# [step] Copy x86_64 binary to output dir
slog_step_se_d --context will "copy x86_64 binary to ${(qqq)x86_dir}"

typeset -r x86_binary="${repo_dir}/.build/x86_64-apple-macosx/release/zbterms"
slog_var1_se_d "x86_binary"

cp "$x86_binary" "${x86_dir}/zbterms" || {
    typeset -i exit_code=$?
    slog_step_se --context fatal --exit-code "$exit_code" "copy x86_64 binary"
    exit $exit_code
}

slog_step_se_d --context success "copied x86_64 binary"

# [step] Build arm64 release binary
slog_step_se_d --context will "build zbterms release for arm64"

typeset -r arm_cmd="swift build --package-path ${(qqq)repo_dir} --product zbterms --configuration release --arch arm64"
slog_var1_se_d "arm_cmd"

typeset arm_build_output=""
arm_build_output="$(eval "$arm_cmd" 2>&1)" || {
    typeset -i exit_code=$?
    slog_step_se --context fatal --exit-code "$exit_code" "build zbterms release for arm64"
    exit $exit_code
}
slog_var1_se_d "arm_build_output"
slog_step_se_d --context success "built zbterms release for arm64"

# [step] Copy arm64 binary to output dir
slog_step_se_d --context will "copy arm64 binary to ${(qqq)arm_dir}"

typeset -r arm_binary="${repo_dir}/.build/arm64-apple-macosx/release/zbterms"
slog_var1_se_d "arm_binary"

cp "$arm_binary" "${arm_dir}/zbterms" || {
    typeset -i exit_code=$?
    slog_step_se --context fatal --exit-code "$exit_code" "copy arm64 binary"
    exit $exit_code
}

slog_step_se_d --context success "copied arm64 binary"

# [step] lipo universal binary (unless --skip-universal)
if [[ -n "$skip_universal" ]]; then
    slog_step_se_d --context info "skipping universal binary (--skip-universal)"
else
    slog_step_se_d --context will "create universal binary via lipo"

    lipo -create -output "${universal_dir}/zbterms" \
        "${x86_dir}/zbterms" \
        "${arm_dir}/zbterms" || {
        typeset -i exit_code=$?
        slog_step_se --context fatal --exit-code "$exit_code" "create universal binary via lipo"
        exit $exit_code
    }

    slog_step_se_d --context success "created universal binary"
fi

# [step] Report output
slog_step_se --context finished "zbterms release binaries written to ${(qqq)output_dir}"
slog_se ""

typeset -a report_dirs=("$x86_dir" "$arm_dir")
[[ -z "$skip_universal" ]] && report_dirs+=("$universal_dir")

for dir in "${report_dirs[@]}"; do
    typeset binary="${dir}/zbterms"
    [[ -f "$binary" ]] || continue
    typeset file_info=""
    file_info="$(lipo -info "$binary" 2>/dev/null | sed 's|.*: ||')"
    slog_se "  " --url "$binary" --default
    slog_se "    ${file_info}"
done
