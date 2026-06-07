#!/bin/sh
set -e
echo "export PATH="/tmp:$PATH"" > /etc/profile.d/99path.sh
if ! command -v xray >/dev/null; then
  7z x -y -bsp0 -bso0 "xray.7z" -o"/tmp"
  chmod +x "/tmp/xray"
  chmod +x "/opt/command.sh"
fi
exec "$@"
