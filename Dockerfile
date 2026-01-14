# syntax=docker/dockerfile:1.4
### STAGE 1:BUILD ###
FROM node:18-alpine AS build
WORKDIR /dist/src/app

# Install dependencies first (better layer caching)
COPY package.json yarn.lock ./
# Use BuildKit cache for npm downloads to speed up repeated installs
RUN --mount=type=cache,target=/root/.npm \
    npm install --no-audit --no-fund --legacy-peer-deps

# Copy source code (excluding files in .dockerignore)
COPY . .

# Build the Angular App in Production Mode
# Use BuildKit cache for Angular persistent build cache
# Disable source maps explicitly to reduce build time/IO
RUN --mount=type=cache,target=.angular/cache \
    npm run build --prod

### STAGE 2:RUN ###
FROM nginx:latest AS ngi
COPY --from=build /dist/src/app/dist/* /usr/share/nginx/html/
COPY ./nginx/default.conf.template /etc/nginx/templates/default.conf.template
EXPOSE 80
