var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  var method;
  beforeEach(function(done) {
    method = console.info;
    done();
  })
  afterEach(function(done) {
    console.info = method;
    done();
  })
  it('should log info message to console.info', function(done) {
    var name = 'mock-console-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var conf = {name: name, console: true, level: logger.INFO};
    console.info = function(message) {
      expect(arguments.length).to.eql(2);
      expect(message).to.eql(msg);
      expect(arguments[1]).to.eql(param);
      done();
    }
    var log = logger(conf);
    log.info(msg, param);
  });
})
