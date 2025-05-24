FROM hugomods/hugo:exts as builder
WORKDIR /src

COPY config.toml .
COPY content ./content/
COPY themes ./themes/

RUN hugo --minify --verbose --debug

FROM hugomods/hugo:nginx
COPY --from=builder /src/public /site