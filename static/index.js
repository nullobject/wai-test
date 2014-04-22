var Bacon = require('bacon.js');

var output = document.getElementsByClassName('container')[0];

var eventSource = new EventSource('/eschan');

var messages = Bacon.fromEventTarget(eventSource, 'message')
  .map(function (e) { return parseInt(e.data); })
  .map(function (value) { return new Date(value); });

messages.onValue(function (message) {
  console.log('Message: ' + message);
});
