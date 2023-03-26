FROM node:18
WORKDIR /app
COPY package.json .
RUN npm i
COPY . .
CMD ["node", "app.js"]