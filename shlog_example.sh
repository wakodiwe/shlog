#!/bin/sh

# Basic logging
./shlog setlevel "info"
./shlog setfile "./shlog_example.log"

echo "--- Basic ---"
./shlog -v debug "debug: hidden (level is info)"
./shlog -v info "info: visible"
./shlog -v warn "warn"
./shlog -v error "error"

echo "--- No Timestamp ---"
LOG_NO_TIMESTAMP=1 ./shlog -v info "this has no timestamp"

echo "--- Custom Format ---"
LOG_FORMAT="%l: %m" ./shlog -v info "minimal format"

echo "--- Config ---"
./shlog conf

echo "--- Rotate ---"
./shlog rotate

echo "--- Clear ---"
./shlog clear
