# Stage 1: Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:stable AS build-env

WORKDIR /app

# Explicitly enable web support in the builder
RUN flutter config --enable-web

# Copy only pubspec first to leverage Docker cache for dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build the web app with optimizations
# Removed --web-renderer auto as it's the default and can occasionally cause issues with certain builder environments
RUN flutter build web --release

# Stage 2: Serve the application using Nginx Alpine
FROM nginx:alpine

# Install curl for health checks
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
