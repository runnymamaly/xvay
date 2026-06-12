#!/bin/sh
set -e
if [ -z "$(ls -A "data" 2>/dev/null)" ]; then
  xcore uuid >"data/uuid"
  xcore x25519 >"data/keys"
fi
ID="$(cat "data/uuid")"
PRIVATE_KEY="$(awk '/PrivateKey/{print $2}' "data/keys")"
PUBLIC_KEY="$(awk '/Password/{print $3}' "data/keys")"
ADDRESS="${ADDRESS:-$(wget -q "ifconfig.me/ip" -O-)}"

if [ -z "${ADDRESS}" ]; then echo "The ADDRESS environment variable must be set!" >&2; exit 1; fi
if [ "${NETWORK}" = "ws" ]; then
  cat >"/etc/xcore.json" <<-EOF
		{
			"log": {
				"access": "none",
				"loglevel": "none"
			},
			"inbounds": [
				{
					"port": 443,
					"protocol": "vless",
					"settings": {
						"clients": [
							{
								"id": "${ID}"
							}
						],
						"decryption": "none"
					},
					"streamSettings": {
						"network": "ws",
						"wsSettings": {
						"path": "${WSPATH}"
						}
					}
				}
			],
			"outbounds": [
				{
					"protocol": "freedom"
				}
			]
		}
	EOF
elif [ "${NETWORK}" = "xhttp" ]; then
  cat >"/etc/xcore.json" <<-EOF
		{
			"log": {
				"access": "none",
				"loglevel": "none"
			},
			"inbounds": [
				{
					"port": 443,
					"protocol": "vless",
					"settings": {
						"clients": [
							{
								"id": "${ID}"
							}
						],
						"decryption": "none"
					},
					"streamSettings": {
						"network": "xhttp",
						"security": "reality",
						"realitySettings": {
							"dest": "${SNI}:443",
							"serverNames": [
								"${SNI}"
							],
						"privateKey": "${PRIVATE_KEY}",
						"shortIds": [
							""
							]
						}
					}
				}
			],
			"outbounds": [
				{
					"protocol": "freedom"
				}
			]
		}
	EOF
elif [ "${NETWORK}" = "tcp" ]; then
  cat >"/etc/xcore.json" <<-EOF
		{
			"log": {
				"access": "none",
				"loglevel": "none"
			},
			"inbounds": [
				{
					"port": 443,
					"protocol": "vless",
					"settings": {
						"clients": [
							{
								"flow": "xtls-rprx-vision",
								"id": "${ID}"
							}
						],
						"decryption": "none"
					},
					"streamSettings": {
						"network": "tcp",
						"security": "reality",
						"realitySettings": {
							"dest": "${SNI}:443",
							"serverNames": [
								"${SNI}"
							],
						"privateKey": "${PRIVATE_KEY}",
						"shortIds": [
							""
							]
						}
					}
				}
			],
			"outbounds": [
				{
					"protocol": "freedom"
				}
			]
		}
	EOF
else
  echo 'The NETWORK environment variable must be set to "tcp", "ws" or "xhttp"!' >&2
  exit 1
fi

exec xcore run -c "/etc/xcore.json" /dev/null 2>&1
