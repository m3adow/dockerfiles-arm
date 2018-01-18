FROM arm32v6/alpine:latest

# When dl.golang.org changes, the download of tar.gz and SHA256SUM will fail
RUN set -ex \
  && apk add --no-cache libc6-compat curl \
  && curl -sLo /tmp/golang.tar.gz $(curl -sL https://golang.org/dl/ \
    | grep -oE 'https?://[a-zA-Z0-9_./-]*go[a-zA-Z0-9_.-]*armv6l.tar.gz' | head -1) \
  && echo "$(curl -sL https://golang.org/dl/ | grep -m1 -A 5 -E 'https?://[a-zA-Z0-9_./-]*go[a-zA-Z0-9_.-]*armv6l.tar.gz' \
    |tail -1|sed -e 's/<[^>]*>//g' -e 's/[[:blank:]]//g')  /tmp/golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf /tmp/golang.tar.gz \
  && rm /tmp/golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

