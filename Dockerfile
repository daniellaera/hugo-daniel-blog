# ------------------ Build Stage ------------------
FROM hugomods/hugo:exts as builder

ARG HUGO_BASEURL
ENV HUGO_BASEURL=${HUGO_BASEURL}

WORKDIR /src
COPY . .

RUN hugo --minify

# ------------------ Final Stage ------------------
FROM hugomods/hugo:nginx

COPY --from=builder /src/public /site