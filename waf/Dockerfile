FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        nginx \
        libnginx-mod-http-modsecurity \
        modsecurity-crs && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY modsec_includes.conf /etc/nginx/modsec_includes.conf
COPY modsecurity.conf /etc/nginx/modsecurity.conf

RUN mkdir -p /var/log/modsecurity

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD curl -fsS http://127.0.0.1/ >/dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80