# Stage 1: Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:stable AS build-env

WORKDIR /app

# Explicitly enable web support
RUN flutter config --enable-web

# Copy only pubspec first
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application
# Note: If using Cloud Build Triggers, firebase_options.dart must be in your repo
# or injected via Secret Manager.
COPY . .

# Build the web app
# --no-wasm-dry-run suppresses warnings about incompatible packages
RUN flutter build web --release --no-wasm-dry-run

# Stage 2: Serve the application using Nginx Alpine
FROM nginx:alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Copy the build output
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Standard port for Cloud Run
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
