FROM node:16.4.0-alpine

RUN apk add nginx git python build-base --no-cache --update && \
    rm -rf /var/cache/apk/* && \
    chown -R nginx:www-data /var/lib/nginx

RUN mkdir /app
WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn
COPY . /app
RUN yarn build

COPY nginx.conf /etc/nginx/
RUN mkdir -p /var/www/html/hot-configs /run/nginx
RUN cp -r build/* /var/www/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]