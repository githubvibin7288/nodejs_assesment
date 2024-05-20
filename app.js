'use strict'

var express = require('express');

var app = express();

app.get('/', function(req, res){
  res.send('Hello World');
});

/* istanbul ignore next */
  app.listen(8084, function() {
  console.log('Express started on port 3000');
});
