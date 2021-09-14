var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  var method;
  beforeEach(function(done) {
    method = console.warn;
    done();
  })
  afterEach(function(done) {
    console.warn = method;
    done();
  })
  it('should log warn message to console.warn', function(done) {
    var name = 'mock-console-logger';
    var msg = 'mock %s message';
    var param = 'warn';
    var conf = {name: name, console: true, level: logger.WARN};
    console.warn = function(message) {
      expect(arguments.length).to.eql(2);
      expect(message).to.eql(msg);
      expect(arguments[1]).to.eql(param);
      done();
    }
    var log = logger(conf);
    log.warn(msg, param);
  });
})
