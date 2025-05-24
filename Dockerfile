# Stage 1
FROM alpine:latest AS build
RUN apk add --no-cache hugo git

WORKDIR /opt/HugoApp
COPY . .
RUN hugo --minify --destination public

# Stage 2
FROM nginx:alpine
COPY --from=build /opt/HugoApp/public /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]