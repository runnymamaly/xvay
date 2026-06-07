#!/bin/sh
set -e
echo "export PATH="/opt:/tmp:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"" >> /etc/profile
if ! command -v xray >/dev/null; then
  7z x -y -bsp0 -bso0 "xray.7z" -o"/tmp"
  chmod +x "/tmp/xray"
  chmod +x "/opt/command.sh"
fi
exec "$@"
