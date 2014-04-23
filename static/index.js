var Bacon = require('bacon.js');
var dom = require('dom');

var output = dom('.container p');

var eventSource = new EventSource('/eschan');

var messages = Bacon.fromEventTarget(eventSource, 'message')
  .map(function (e) { return new Date(parseInt(e.data)); });

messages.onValue(function (message) {
  output.text(message);
});
