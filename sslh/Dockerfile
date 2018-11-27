FROM arm32v6/alpine:latest

RUN echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk --no-cache add curl libconfig libconfig-dev make gcc dumb-init \
    build-base pcre pcre-dev \
  && curl -sL https://github.com/yrutschle/sslh/archive/$(curl -sL https://github.com/yrutschle/sslh/releases \
    | grep -m 1 -E -o 'v[0-9A-Za-z._-]*.tar.gz"'| sed 's/"$//') \
    | tar -C /srv/ -xz \
  && sed -i 's/^\(USELIBPCRE=\)/\11/' /srv/sslh-*/Makefile \
  && make -C /srv/sslh-* \
  && mv /srv/sslh-*/sslh-fork /srv/sslh-*/sslh-select /usr/local/bin/ \
  && rm -rf /srv/sslh-* \
  && apk del --purge gcc build-base libconfig-dev pcre-dev make

COPY ["configure-sslh.sh", "/usr/local/bin/"]

ENTRYPOINT ["/usr/bin/dumb-init", "/usr/local/bin/configure-sslh.sh"]
