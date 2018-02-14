var package = require(“. / package.json”);
var api = require(“. / lib / api.js”);
console.log(“loaded” + package.name + “, version” + package.version);
exports.handler = function(event, context) {
  myNewApi.handleRequest(event, context.done);
}
