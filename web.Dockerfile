FROM node:11.4.0-stretch-slim

COPY package.json /app/package.json
WORKDIR /app

RUN npm install
RUN npm install -g truffle 

COPY . /app

USER root
ENTRYPOINT ["/bin/sh"]
EXPOSE 3000 3001