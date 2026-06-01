FROM node:20-alpine

RUN apk add --no-cache curl

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 30002

CMD ["node", "app.js"]
