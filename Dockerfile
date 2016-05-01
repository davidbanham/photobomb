FROM mhart/alpine-node:4

RUN apk add --update \
    python \
    python-dev \
    build-base

WORKDIR /opt/app

COPY ./package.json /opt/app/package.json
RUN npm install

COPY . /opt/app/

EXPOSE 3000

ENV PORT=3000
CMD ["node", "index.js"]
