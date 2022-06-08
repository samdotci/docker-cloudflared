#!/bin/sh -e

if [[ -z "${CLOUDFLARE_TUNNEL_UUID}" ]]; then
    echo "CLOUDFLARE_TUNNEL_UUID is not set"
    exit 1
fi

if [[ ! -d "/etc/cloudflared" ]]; then
    mkdir -p /etc/cloudflared
fi

if [[ -n "${CLOUDFLARE_CONFIG_YML}" ]]; then
    echo >&2 "CLOUDFLARE_CONFIG_YML value found: "
    echo "$CLOUDFLARE_CONFIG_YML" >"/etc/cloudflare/config.yml"
fi

if [[ -n "${CLOUDFLARE_CERT_PEM}" ]]; then
    echo >&2 "CLOUDFLARE_CERT_PEM value found: "
    echo "$CLOUDFLARE_CERT_PEM" >"/etc/cloudflare/cert.pem"
fi

if [[ -n "${CLOUDFLARE_TUNNEL_JSON}" ]]; then
    echo >&2 "CLOUDFLARE_TUNNEL_JSON value found: "
    echo "$CLOUDFLARE_TUNNEL_JSON" >"/etc/cloudflared/${CLOUDFLARE_TUNNEL_UUID}.json"
fi

exec "$@"

