FROM node:18-slim

COPY . /build
WORKDIR /build
RUN npm ci --omit=dev && npm run build
