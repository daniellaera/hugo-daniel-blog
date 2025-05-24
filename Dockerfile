FROM hugomods/hugo:exts AS builder
WORKDIR /src

COPY config.toml .
COPY content ./content/
COPY layouts ./layouts/
COPY static ./static/
COPY themes ./themes/

RUN hugo --minify

FROM hugomods/hugo:nginx

# Copy built site
COPY --from=builder /src/public /site

# Fix permissions so nginx can read the files
RUN chown -R nginx:nginx /site && chmod -R 755 /site

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]