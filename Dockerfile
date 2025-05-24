# Stage 1: Build Eleventy site
FROM node:20-alpine AS build

WORKDIR /app
COPY . .
RUN npm install
RUN npx @11ty/eleventy

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/_site /usr/share/nginx/html