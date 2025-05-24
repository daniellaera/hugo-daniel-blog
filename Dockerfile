# Build Hugo site
FROM hugomods/hugo:latest AS builder
WORKDIR /src
COPY . .
RUN hugo --minify

# Serve with nginx
FROM nginx:alpine
COPY --from=builder /src/public /usr/share/nginx/html
EXPOSE 80