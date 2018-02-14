var assert = require(“chai”).assert;
var api = require(“.. / lib / api.js”);
describe(“JaysonChainApi”, function() {
  it(“exports handleRequest”, function() {
    assert.typeOf(api.handleRequest, “function”);
  });
});
