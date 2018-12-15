FROM node:8 as builder
LABEL maintainer="Florius <j@florius.com.ar>"

WORKDIR /app

ADD package-lock.json /app/package-lock.json
ADD package.json /app/package.json

ENV PATH=$PATH:/app/node_modules/.bin
RUN npm install

ADD . /app

RUN npm run build

# Run static server
FROM nginx:1.15-alpine
LABEL maintainer="Florius <j@florius.com.ar>"

COPY server/server.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000

COPY --from=builder /app/build /usr/share/nginx/html