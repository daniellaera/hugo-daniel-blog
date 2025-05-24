# Stage 1: build Hugo site
FROM hugomods/hugo:latest AS builder
WORKDIR /src
COPY . .
RUN hugo

# Stage 2: serve with nginx
FROM nginx:alpine
COPY --from=builder /src/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]