FROM node:alpine
WORKDIR /myapp
COPY ./package.json /myapp/package.json
COPY ./app.js /myapp/app.js
RUN npm install express --save
EXPOSE 3000
CMD [ "node","app.js" ]
