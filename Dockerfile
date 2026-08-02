# Sitio de cuenta/legal de Mándalo (somosmandalo.com, Dokploy):
# eliminar-cuenta, privacidad, términos — NOTAS.md §49. Astro genera HTML
# estático real (no es una SPA) — nginx solo sirve archivos, sin rewrites.
#
# ⚠️ Build arg en Dokploy (se HORNEA en el JS del formulario al compilar):
#   PUBLIC_API_URL (opcional) = URL del backend al que pega el formulario de
#   "eliminar cuenta". Sin él, el default es PROD
#   (https://apiprod.somosmandalo.com). Para una versión DEV de este
#   sitio: https://apidev.somosmandalo.com.

FROM node:22-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

ARG PUBLIC_API_URL=https://apiprod.somosmandalo.com
ENV PUBLIC_API_URL=$PUBLIC_API_URL

RUN npm run build

FROM nginx:alpine AS production

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
