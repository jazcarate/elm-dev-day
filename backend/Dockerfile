FROM node:8
LABEL maintainer="Florius <j@florius.com.ar>"

WORKDIR /app

ADD package-lock.json /app/package-lock.json
ADD package.json /app/package.json

ENV PATH=$PATH:/app/node_modules/.bin
RUN npm install

ADD . /app

EXPOSE 3000

CMD ["npm", "start"]