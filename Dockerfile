# syntax=docker/dockerfile:1.4
### STAGE 1:BUILD ###
FROM node:18-alpine AS build
WORKDIR /dist/src/app

# Install dependencies first (better layer caching)
COPY package.json package-lock.json ./
# Use BuildKit cache for npm downloads to speed up repeated installs
RUN --mount=type=cache,target=/root/.npm \
    npm ci --no-audit --no-fund --legacy-peer-deps

# Copy source code (excluding files in .dockerignore)
COPY . .

# Build the Angular App in Production Mode
# Use BuildKit cache for Angular persistent build cache
RUN --mount=type=cache,target=/dist/src/app/.angular/cache \
    npm run build -- --configuration production

### STAGE 2:RUN ###
FROM nginx:1.27-alpine AS ngi
# Folder inside dist/ that contains index.html.
# Angular 16 and earlier: dist/<app>; Angular 17+: dist/<app>/browser
ARG DIST_DIR=dist/*
COPY --from=build /dist/src/app/${DIST_DIR} /usr/share/nginx/html/
COPY ./nginx/default.conf.template /etc/nginx/templates/default.conf.template
EXPOSE 80
