FROM node:20-alpine AS build
WORKDIR /app
# copy package files (includes package-lock.json if present)
COPY package*.json ./
# prefer npm ci when lockfile exists, otherwise fall back to npm install
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi
COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
