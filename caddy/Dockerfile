FROM container4armhf/armhf-alpine:latest

RUN apk add --no-cache curl bash \
    && curl https://getcaddy.com \
    | bash -s http.filemanager,http.upload,tls.dns.cloudflare \
    && apk del --purge curl bash \
    && apk add --no-cache ca-certificates

ENTRYPOINT ["/usr/local/bin/caddy"]
