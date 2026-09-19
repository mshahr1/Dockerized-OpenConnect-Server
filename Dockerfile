FROM alpine:latest AS builder
RUN apk add --no-cache build-base meson ninja gnutls-dev readline-dev \
    libnl3-dev lz4-dev libseccomp-dev talloc-dev libev-dev protobuf-c-dev \
    linux-headers curl tar xz
WORKDIR /build
RUN curl -O ftp://ftp.infradead.org/pub/ocserv/ocserv-1.5.0.tar.xz && \
    tar -xf ocserv-1.5.0.tar.xz && \
    cd ocserv-1.5.0 && \
    meson setup build && \
    ninja -C build install
FROM alpine:latest
RUN apk add --no-cache gnutls gnutls-utils iptables libev libnl3 \
    lz4-libs readline libseccomp talloc protobuf-c
COPY --from=builder /usr/local/sbin/ocserv* /usr/sbin/
COPY --from=builder /usr/local/bin/ocpasswd /usr/bin/
COPY --from=builder /usr/local/bin/occtl /usr/bin/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /etc/ocserv
ENTRYPOINT ["/entrypoint.sh"]
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
