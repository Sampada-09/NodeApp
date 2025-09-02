# Stage 1: Build React app
FROM node:20 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy the Vite output (dist folder) to Nginx
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 10000

CMD ["nginx", "-g", "daemon off;"]
