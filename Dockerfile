# Stage 1: Build the Flutter web application
# Using a specialized lightweight build image for Flutter
FROM ghcr.io/cirruslabs/flutter:stable AS build-env

WORKDIR /app

# Copy only pubspec first to leverage Docker cache for dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build the web app with optimizations
# --web-renderer canvaskit offers better performance but larger size
# --web-renderer html is smaller but might have some rendering differences
# Using 'auto' is the professional middle ground
RUN flutter build web --release --web-renderer auto

# Stage 2: Serve the application using Nginx Alpine
# Alpine is significantly smaller than standard Debian/Ubuntu images
FROM nginx:alpine

# Install curl for health checks (standard in professional Cloud Run deployments)
RUN apk add --no-cache curl

# Copy the build output from the first stage
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Standard port for Cloud Run
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
