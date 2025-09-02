# Stage 1: Build React app
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install --frozen-lockfile

COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy React build to Nginx HTML folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 10000 for Render
EXPOSE 10000

# Render expects your app to bind to $PORT
ENV PORT=10000

# Replace default nginx config so it listens on $PORT
RUN sed -i "s/listen       80;/listen       ${PORT};/" /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
