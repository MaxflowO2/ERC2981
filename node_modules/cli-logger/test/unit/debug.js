var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should log debug message', function(done) {
    var msg = 'mock debug message';
    var name = 'mock-debug-logger';
    var conf = {name: name, level: logger.DEBUG};
    var log = logger(conf);
    expect(log.debug()).to.eql(true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    log.debug(msg);
  });
  it('should ignore debug with info level', function(done) {
    var name = 'mock-debug-logger';
    var conf = {name: name};
    var log = logger(conf);
    expect(log.debug()).to.eql(false);
    log.debug('mock %s message to ignore', 'debug');
    done();
  });
})
