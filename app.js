'use strict'

var express = require('express');

var app = express();

app.get('/', function(req, res){
  res.send('Hi this is vibin, My project completed\n');
});

/* istanbul ignore next */
if (!module.parent) {
  app.listen(3000);
  console.log('Express started on port 3000');
}
