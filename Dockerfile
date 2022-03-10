FROM debian:stable-slim

RUN apt update && apt install -y curl \
    && curl -SL https://github.com/gohugoio/hugo/releases/download/v0.93.3/hugo_extended_0.93.3_Linux-64bit.tar.gz -o /tmp/hugo.tar.gz \
    && tar -xzf /tmp/hugo.tar.gz -C /tmp \
    && mv /tmp/hugo /usr/local/bin/ \
    && rm -rf /tmp/*

EXPOSE 1313

CMD hugo server \
    --bind 0.0.0.0 \
    --navigateToChanged \
    --buildDrafts
