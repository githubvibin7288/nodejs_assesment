FROM node:alpine
COPY ./ ./
RUN npm install express
EXPOSE 3000
CMD [ "npm","start" ]
