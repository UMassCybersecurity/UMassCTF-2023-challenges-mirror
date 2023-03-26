FROM node:18-slim

WORKDIR /FRY

COPY package.json .

RUN npm i

COPY . .

CMD ["node", "./app.js"]
