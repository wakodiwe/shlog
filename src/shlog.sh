#!/usr/bin/env sh
# Minimal POSIX sh Python-logging flavored utility. Single file. No dependencies.
set -eu
VERSION=0.0.1

SHLOG_COLOR="${SHLOG_COLOR:-1}"
SHLOG_FILE="${SHLOG_FILE:=}"
SHLOG_FORMAT="${SHLOG_FORMAT:-%(asctime)s [%(levelname)s] <%(name)s> %(message)s}"
SHLOG_LEVEL="${SHLOGLEVEL:-2}"
SHLOG_NAME="${SHLOG_NAME:=main}"
SHLOG_TIME_STRING="${SHLOG_TIME_STRING:-%H:%M:%S}"

case $0 in
    /*) PROGPATH=$0 ;;
    *)  PROGPATH=$PWD/$0 ;;
esac
PROGDIR=${PROGPATH%/*}
PROGNAME=${PROGPATH##*/}

usage() {
    printf '%s\n' "Usage: $PROGNAME..."
    exit "${1:-0}"
}

argparsh() {
    if [ "$#" -eq 1 ]; then
        case "$1" in
            -V | --version)
                printf '%s' "$VERSION"
                exit 1
                ;;
            --)
                shift
                return 1
                ;;
            -*)
                printf "%s\n" "Unknown option: $1"
                usage 1
                ;;
            *)
                return 1
                ;;
        esac
    fi
}
argparsh "$@"

_log_colors() {
    case "$1" in
        -1) _color=31 ;;  # ERROR, red
        0) _color=33 ;;   # WARN, yellow
        1) _color=32 ;;   # INFO, green
        2) _color=36 ;;   # DEBUG, cyan
        *) _color=0 ;;    # default, none
    esac
}
_log_str_esc() {
    sed -e 's/\\/\\\\/g' -e 's/&/\\&/g' -e 's/|/\\|/g'
}

_log_levels() {
    case "$1" in
        -1) _levelname="${SHLOG_LEVEL_ERROR:-ERROR}" ;;
        0) _levelname="${SHLOG_LEVEL_WARN:-WARN}" ;;
        1) _levelname="${SHLOG_LEVEL_INFO:-INFO}" ;;
        2) _levelname="${SHLOG_LEVEL_DEBUG:-DEBUG}" ;;
        *) _levelname="${SHLOG_LEVEL_SHLOG:-SHLOG}" ;;
    esac
}

_log_format() {
    printf '%s' "$SHLOG_FORMAT" | sed \
        -e "s|%(name)s|$3|g" \
        -e "s|%(message)s|$4|g" \
        -e "s|%(asctime)s|$1|g" \
        -e "s|%(levelname)s|$2|g" \
        -e "s|%(levelshort)s|${2%"${2#?}"}|g"
}

DISABLED_NAMES=" "
_log_is_enabled() {
    case "$DISABLED_NAMES" in
        *" $1 "*) return 1 ;;
        *) return 0 ;;
    esac
}

# Keep this as it is: Used as separator byte. Normally never occurs in a real message.
_SHLOG_SEP="$(printf '\036')"

_log() {
    _level="$1"
    shift

    [ "$SHLOG_LEVEL" -lt "$_level" ] \
        && return 0

    if [ "$_level" -ne -1 ]; then
        _log_is_enabled "$SHLOG_NAME" \
            || return 0
    fi

    _asctime="$(date "+$SHLOG_TIME_STRING")"
    _log_levels "$_level"

    _name_text="$(printf '%s%s%s' "$SHLOG_NAME" "$_SHLOG_SEP" "$*" | _log_str_esc)"
    _name="${_name_text%%"$_SHLOG_SEP"*}"
    _text="${_name_text#*"$_SHLOG_SEP"}"

    _line="$(_log_format "$_asctime" "$_levelname" "$_name" "$_text")"

    if [ "$SHLOG_COLOR" -eq 1 ]; then
        _log_colors "$_level"
        printf '\033[%sm%b\033[0m\n' "$_color" "$_line" >&2
    else
        printf '%b\n' "$_line" >&2
    fi

    [ -n "$SHLOG_FILE" ] \
        && printf '%s\n' "$_line" \
            >> "$SHLOG_FILE"

    [ "$_level" -eq -1 ] \
        && exit 1

    return 0
}

log_disable() {
    for _n in "$@"; do
        case "$DISABLED_NAMES" in
            *" $_n "*) ;;
            *) DISABLED_NAMES="$DISABLED_NAMES$_n " ;;
        esac
    done
}

log_enable() {
    for _n in "$@"; do
        DISABLED_NAMES=$(
            printf '%s' "$DISABLED_NAMES" \
                | sed "s/ $_n / /g"
        )
    done
}

log_name() {
    SHLOG_NAME="${1:-$SHLOG_NAME}"
}

log_msg() {
    [ "$SHLOG_LEVEL" -eq -1 ] \
        && return 1

    printf '%b' "$1"

    if [ "$#" -ge 2 ]; then
        printf '%b' "$2"
        return 0
    fi

    printf '\n'
}

log_die() {
    _log -1 "$*"
}

log_error() {
    log_die "$@"
}

log_warn() {
    _log 0 "$*"
}

log_info() {
    _log 1 "$*"
}

log_debug() {
    _log 2 "$*"
}
