# Stage 1: Build Hugo site
FROM hugomods/hugo:exts AS builder

WORKDIR /src

# Copy package files first for better caching
COPY package*.json go.* hugo.* config.* ./

# Copy source directories
COPY content ./content/
COPY layouts ./layouts/
COPY static ./static/
COPY assets ./assets/
COPY archetypes ./archetypes/

# Copy themes - handle both git submodules and direct copies
COPY themes ./themes/

# Install dependencies if they exist
RUN if [ -f "package.json" ]; then npm ci --only=production; fi

# Build the site with verbose output for debugging
RUN hugo --minify --verbose --debug

# Stage 2: Serve with nginx
FROM nginx:alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Copy built site from Hugo to Nginx
COPY --from=builder /src/public /usr/share/nginx/html/

# Copy custom nginx config if needed
# COPY nginx.conf /etc/nginx/nginx.conf

# Create nginx user and set permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80

# Use exec form for proper signal handling
CMD ["nginx", "-g", "daemon off;"]