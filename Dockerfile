FROM node:alpine
WORKDIR /myapp
COPY ./package.json /myapp/package.json
COPY ./app.js /myapp/app.js
RUN npm install express --save
EXPOSE 8100
ENTRYPOINT [ "node","app.js" ]
