#!/bin/sh
set -e
if ! command -v xray >/dev/null; then
  7z x -y -bsp0 -bso0 "xray.7z" -o"/tmp"
  cp "/tmp/xray" "/usr/local/bin/"
  chmod +x "/usr/local/bin/xray"
  chmod +x "/tmp/xray"
  chmod +x "/opt/command.sh"
fi
exec "$@"
