FROM hugomods/hugo:exts AS builder
WORKDIR /src

COPY config.toml .
COPY content ./content/
COPY themes ./themes/

RUN hugo --minify

FROM hugomods/hugo:nginx
COPY --from=builder /src/public /site