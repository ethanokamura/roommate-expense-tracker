FROM node:18
WORKDIR /server/src
COPY package*.json ./
RUN npm install

COPY . .
EXPOSE 3001
CMD ["node", "server.js"]