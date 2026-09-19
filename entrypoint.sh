#!/bin/sh

# فعال‌سازی NAT برای ترافیک خروجی از کانتینر
iptables -t nat -A POSTROUTING -j MASQUERADE

# اجازه عبور ترافیک از فایروال داخلی کانتینر
iptables -I FORWARD -j ACCEPT

# تنظیم خودکار سایز بسته‌ها (MTU) برای جلوگیری از تایم‌اوت در شبکه‌های محدود
iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# اجرای سرویس اصلی ocserv
exec "$@"
