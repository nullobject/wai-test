var Bacon = require('bacon.js');
var dom = require('dom');

var output = dom('.container p');

var eventSource = new EventSource('/eschan');

var messages = Bacon.fromEventTarget(eventSource, 'message')
  .map(function (e) { return parseInt(e.data); })
  .map(function (value) { return new Date(value); });

messages.onValue(function (message) {
  output.text(message);
});
