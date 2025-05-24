# Stage 1: Build Hugo site
FROM hugomods/hugo:latest AS builder

WORKDIR /src

# Copy only what's needed first to leverage Docker caching
COPY config.toml ./
COPY content ./content
COPY layouts ./layouts
COPY static ./static
COPY themes ./themes
COPY assets ./assets
COPY archetypes ./archetypes

# Optional: clean stale public folder and ensure clean build
RUN rm -rf public && hugo --minify

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built site from Hugo to Nginx
COPY --from=builder /src/public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]