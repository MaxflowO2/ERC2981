var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  var method;
  beforeEach(function(done) {
    method = console.error;
    done();
  })
  afterEach(function(done) {
    console.error = method;
    done();
  })
  it('should log error message to console.error', function(done) {
    var name = 'mock-console-logger';
    var msg = 'mock %s message';
    var param = 'error';
    var conf = {name: name, console: true, level: logger.ERROR};
    console.error = function(message) {
      expect(arguments.length).to.eql(2);
      expect(message).to.eql(msg);
      expect(arguments[1]).to.eql(param);
      done();
    }
    var log = logger(conf);
    log.error(msg, param);
  });
})
