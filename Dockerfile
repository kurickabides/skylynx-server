# Stage 1: Build Server
FROM node:18 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

# Stage 2: Run Host
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/build ./build
COPY package*.json ./

RUN npm install --only=production

EXPOSE 3200

CMD ["node", "build/server.js"]
