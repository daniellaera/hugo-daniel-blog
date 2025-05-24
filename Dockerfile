# Stage 1: Build Hugo site
FROM hugomods/hugo:exts AS builder

WORKDIR /src

COPY config.* ./
COPY content ./content/
COPY layouts ./layouts/
COPY static ./static/
COPY themes ./themes/

RUN hugo --minify --verbose --debug

# Stage 2: Serve with nginx
FROM nginx:alpine

RUN apk add --no-cache curl

COPY --from=builder /src/public /usr/share/nginx/html/

RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]