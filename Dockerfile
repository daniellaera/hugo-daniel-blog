# Stage 1: Build
FROM node:18-alpine AS build
WORKDIR /app
COPY . .
RUN npm install
RUN npx @11ty/eleventy

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/_site /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]