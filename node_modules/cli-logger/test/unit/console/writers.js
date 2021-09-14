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
  it('should log all messages to console.error', function(done) {
    var name = 'mock-console-logger';
    var msg = 'mock %s message';
    console.error = function(message) {
      written++;
      expect(arguments.length).to.eql(2);
      if(written === logger.keys.length) done();
    }
    var conf = {
      name: name, console: true,
      level: logger.TRACE, writers: console.error};
    var written = 0;
    var log = logger(conf);
    logger.keys.forEach(function(method) {
      log[method](msg, method);
    })
  });
  it('should log trace|debug|info messages to console.error', function(done) {
    var name = 'mock-console-logger';
    var msg = 'mock %s message';
    console.error = function(message) {
      written++;
      expect(arguments.length).to.eql(2);
      if(written === 3) done();
    }
    var conf = {
      name: name, console: true,
      level: logger.TRACE,
      writers: {
        trace: console.error,
        debug: console.error,
        info: console.error
      }
    };
    var written = 0;
    var log = logger(conf);
    log.trace(msg, 'trace');
    log.debug(msg, 'debug');
    log.info(msg, 'info');
  });
})
