FROM node:7.7.0

# yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 0.21.3

# Cache dependencies
COPY yarn.lock /tmp/yarn.lock
COPY package.json /tmp/package.json
RUN mkdir -p /opt/app && \
    cd /opt/app && \
    cp /tmp/yarn.lock . && \
    cp /tmp/package.json . && \
    yarn install --production --loglevel warn

COPY . /opt/app

WORKDIR /opt/app

CMD ["npm", "start"]
