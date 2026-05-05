#!/usr/bin/env sh
# install.sh - Install shlog

set -euf

PREFIX="${PREFIX:-$HOME/.local}"
DEST="$PREFIX/bin/shlog"
URL="https://raw.githubusercontent.com/wakodiwe/shlog/main/shlog"

mkdir -p "$(dirname "$DEST")"
curl -fsSL "$URL" -o "$DEST"
chmod 644 "$DEST"

printf "Installed to %s\n" "$DEST"
printf "Usage: . %s\n" "$DEST"
