var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  var method;
  beforeEach(function(done) {
    method = console.log;
    done();
  })
  //afterEach(function(done) {
    //console.log = method;
    //done();
  //})
  it('should log trace message to console.log', function(done) {
    var name = 'mock-console-logger';
    var msg = 'mock %s message';
    var param = 'trace';
    var conf = {name: name, console: true, level: logger.TRACE};
    console.log = function(message) {
      expect(arguments.length).to.eql(2);
      expect(message).to.eql(msg);
      expect(arguments[1]).to.eql(param);
      // have to revert method here for mocha to be ok
      console.log = method;
      done();
    }
    var log = logger(conf);
    log.trace(msg, param);
  });
})
