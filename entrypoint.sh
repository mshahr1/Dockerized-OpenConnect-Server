#!/bin/sh

iptables -t nat -A POSTROUTING -j MASQUERADE

iptables -I FORWARD -j ACCEPT

iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

exec "$@"
