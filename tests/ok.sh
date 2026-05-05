#!/usr/bin/env sh
# ok.sh - Minimal POSIX shell test harness

[ -n "${TEST_SH_SOURCED:-}" ] && return 0 2>/dev/null || true
TEST_SH_SOURCED=true

: "${TEST_VERBOSE:=false}"
: "${SOURCE:=false}"

_passed=0
_failed=0
_total=0

_passed_char="\033[32m+\033[0m"
_failed_char="\033[31m-\033[0m"

msg() { printf "%b\n" "$*" >&2; }
log() { [ "${TEST_VERBOSE}" != false ] &&  msg "${*}"; }

pass() {
    log "${_passed_char} $*"
    _passed=$((_passed+1))
    _total=$((_total+1))
}
fail() {
    msg "${_failed_char} $*"
    _failed=$((_failed+1))
    _total=$((_total+1))
}

run() {
    _out=
    if [ "$SOURCE" = true ]; then
        # shellcheck source=/dev/null
        _out=$(set -- "$@"; . "$SCRIPT" 2>&1)
        _ret=$?
    else
        _out=$(sh "$SCRIPT" "$@" 2>&1)
        _ret=$?
    fi
}

run_shellcheck() {
    if command -v shellcheck >/dev/null 2>&1; then
        if shellcheck "$SCRIPT" >/dev/null 2>&1; then
            pass "shellcheck"
        else
            fail "shellcheck"
        fi
    fi
}

assert_eq() {
    _exp="$1"
    _act="$2"
    _name="$3"
    if [ "$_exp" = "$_act" ]; then
        pass "$_name"
    else
        fail "${_name:-eq} (expected '$_exp', got '$_act')"
    fi
}

assert_contains() {
    _needle="$1"
    _hay="$2"
    _name="$3"
    case "$_hay" in
        *"$_needle"*)
            pass "$_name"
            ;;
        *)
            fail "${_name:-contains} ('$_needle' not found)"
            ;;
    esac
}

assert_exit() {
    _exp="$1"
    _name="$2"
    if [ "$_ret" -eq "$_exp" ]; then
        pass "$_name"
    else
        fail "${_name:-exit} (expected $_exp, got $_ret)"
    fi
}

discover_tests() {
    grep -E '^[[:space:]]*test_[a-zA-Z0-9_]*[[:space:]]*\(\)' "$0" \
        | sed 's/[[:space:]]*(.*//' \
        | sed 's/^[[:space:]]*//'
}

run_tests() {
    : "${SCRIPT:?SCRIPT not set}"
    msg "--- Test: $SCRIPT"

    run_shellcheck
    for t in $(discover_tests); do
        $t
    done

    msg "$_total run, $_failed failed"
}
