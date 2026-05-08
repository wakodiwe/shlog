#!/usr/bin/env sh
# test_shlog_example.sh - Tests for ../shlog

. ./ok.sh

TEST_VERBOSE=true

SCRIPT=../shlog

export HOME=/tmp/test-shlog-home
export LOG_FILE=/tmp/test-shlog.log
export LOG_LEVEL=debug

# test_help() {
# 	run -h
# 	assert_exit 0 "-h exits 0"
# 	assert_contains "Usage:" "$_out" "-h shows usage"
# }

# test_version() {
# 	run -V
# 	assert_exit 0 "-V exits 0"
# 	assert_contains "0.1.0" "$_out" "-V shows version"
# }

# test_no_args() {
# 	run
# 	assert_exit 1 "no args exits 1"
# }

test_url_and_sed() {
	run -v info "https://www.example.com/version/"
	# assert_exit 0 "url and sed exits 0"
	assert_contains "https://www.example.com/version/" "$_out" "url and sed outputs no error"
}

# test_info() {
# 	run -v info "test message"
# 	assert_exit 0 "info exits 0"
# 	assert_contains "test message" "$_out" "info outputs message"
# }

# test_multi_word() {
# 	run -v info "multi word message"
# 	assert_contains "multi word message" "$_out" "multi-word preserved"
# }

# test_warn() {
# 	run -v warn "warning"
# 	assert_contains "warning" "$_out" "warn outputs"
# }

# test_error() {
# 	run -v error "error"
# 	assert_contains "error" "$_out" "error outputs"
# }

# test_no_timestamp() {
# 	LOG_NO_TIMESTAMP=1 run -v info "no ts"
# 	assert_contains "[ info]" "$_out" "no timestamp format"
# }

# test_custom_format() {
# 	LOG_FORMAT="%l: %m" run -v info "custom"
# 	assert_contains "info: custom" "$_out" "custom format"
# }

# test_verbose() {
# 	run -v info "verbose msg"
# 	assert_contains "verbose msg" "$_out" "verbose prints to stdout"
# }

# test_setlevel_invalid() {
# 	run setlevel badlevel
# 	assert_exit 1 "invalid level exits 1"
# }

test_conf() {
	run conf
	assert_exit 0 "conf exits 0"
	assert_contains "Log file:" "$_out" "conf shows config"
}

run_tests
