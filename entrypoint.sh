#!/bin/sh

# Replace the placeholder in index.html with the actual environment variable
if [ ! -z "$API_BASE_URL" ]; then
  sed -i "s|API_BASE_URL_PLACEHOLDER|$API_BASE_URL|g" /usr/share/nginx/html/index.html
fi

# Start Nginx
nginx -g "daemon off;"
