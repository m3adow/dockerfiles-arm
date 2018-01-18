FROM arm32v6/alpine:latest

RUN apk add --no-cache curl bash gnupg\
    && curl https://getcaddy.com \
    | bash -s http.filemanager,http.upload,tls.dns.cloudflare \
    && apk del --purge curl bash gnupg \
    && apk add --no-cache ca-certificates

ENTRYPOINT ["/usr/local/bin/caddy"]
