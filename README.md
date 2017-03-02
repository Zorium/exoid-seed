API Seed
========

### Getting Started

```
yarn install
yarn run dev
```

### Commands

 - `yarn run dev` start server, watching
 - `yarn test`
 - `yarn run watch` watch tests

### Production

```
# generate ES256 key pair
openssl ecparam -genkey -name prime256v1 > key.pem
openssl ec -pubout < key.pem > key.pub
```

```
export JWT_ES256_PRIVATE_KEY=<key>
export JWT_ES256_PUBLIC_KEY=<key>
yarn start
```
