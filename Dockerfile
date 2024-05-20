FROM node:alpine
WORKDIR /myapp
COPY ./package.json /myapp/package.json
COPY ./app.js /myapp/app.js
RUN npm install express --save
EXPOSE 3000
ENTRYPOINT [ "node","app.js" ]
