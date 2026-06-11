#!/bin/sh
set -e

ID="$(cat "data/uuid")"
PUBLIC_KEY="$(awk '/Password/{print $3}' "data/keys")"
ADDRESS="${ADDRESS:-$(wget -q "ifconfig.me/ip" -O-)}"

if [ -z "${ADDRESS}" ]; then echo "The ADDRESS environment variable must be set!" >&2; exit 1; fi
if [ "${NETWORK}" = "ws" ]; then
  echo "vless://${ID}@${ADDRESS}:${PORT}?encryption=none&security=tls&sni=${ADDRESS}&fp=chrome&alpn=http%2F1.1&insecure=0&allowInsecure=0&type=ws&path=${WSPATH}#${ADDRESS}" | qrencode -t ansiutf8
  echo
  echo "vless://${ID}@${ADDRESS}:${PORT}?encryption=none&security=tls&sni=${ADDRESS}&fp=chrome&alpn=http%2F1.1&insecure=0&allowInsecure=0&type=ws&path=${WSPATH}#${ADDRESS}"

elif [ "${NETWORK}" = "xhttp" ]; then
  echo "vless://${ID}@${ADDRESS}:${PORT}?type=xhttp&security=reality&pbk=${PUBLIC_KEY}&sni=${SNI}&fp=chrome#${ADDRESS}" | qrencode -t ansiutf8
  echo
  echo "vless://${ID}@${ADDRESS}:${PORT}?type=xhttp&security=reality&pbk=${PUBLIC_KEY}&sni=${SNI}&fp=chrome#${ADDRESS}"
  
elif [ "${NETWORK}" = "tcp" ]; then
  echo "vless://${ID}@${ADDRESS}:${PORT}?type=tcp&flow=xtls-rprx-vision&security=reality&pbk=${PUBLIC_KEY}&sni=${SNI}&fp=chrome#${ADDRESS}" | qrencode -t ansiutf8
  echo
  echo "vless://${ID}@${ADDRESS}:${PORT}?type=tcp&flow=xtls-rprx-vision&security=reality&pbk=${PUBLIC_KEY}&sni=${SNI}&fp=chrome#${ADDRESS}"
  
else
  echo 'The NETWORK environment variable must be set to "ws", "tcp" or "xhttp"!' >&2
  exit 1
fi

{
  echo
  echo "Address: ${ADDRESS}"
  echo "Port: ${PORT}"
  echo "Network: ${NETWORK:-tcp}"
  echo "ID: ${ID}"
  echo "PublicKey: ${PUBLIC_KEY}"
  echo "SNI: ${SNI}"
  echo "Path: ${WSPATH}"
  echo
} | column -L -t
