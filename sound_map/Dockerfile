# Step 1: Use a Node.js image to build the Flutter web app
FROM node:16 as build-stage

# Install Flutter
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/root/.pub-cache/bin:${PATH}"

# Enable flutter web
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Copy the project files into the container
WORKDIR /app
COPY . .

# Install dependencies and build the Flutter web app
RUN flutter pub get
RUN flutter build web --release

# Step 2: Use NGINX to serve the web app
FROM nginx:alpine

# Copy the build files from the previous stage
COPY --from=build-stage /app/build/web /usr/share/nginx/html

# Expose port 8080 (required by Cloud Run)
EXPOSE 8080

# Replace the default NGINX configuration with a custom one to listen on port 8080
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
