#!/bin/sh
set -e
if ! command -v xcore >/dev/null; then
  7z x -y -bsp0 -bso0 "xcore.7z" -o"/usr/local/bin/"
  rm -rf "xcore.7z"
  chmod +x "/usr/local/bin/xcore"
  chmod +x "/opt/command.sh"
  chmod +x "/opt/configs.sh"
fi
exec "$@"
