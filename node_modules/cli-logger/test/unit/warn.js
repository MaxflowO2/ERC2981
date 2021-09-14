var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should log warn message', function(done) {
    var msg = 'mock warn message';
    var name = 'mock-warn-logger';
    var conf = {name: name, level: logger.WARN};
    var log = logger(conf);
    expect(log.warn()).to.eql(true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    log.warn(msg);
  });
  it('should ignore warn with error level', function(done) {
    var name = 'mock-warn-logger';
    var conf = {name: name, level: logger.ERROR};
    var log = logger(conf);
    expect(log.warn()).to.eql(false);
    log.warn('mock %s message to ignore', 'warn');
    done();
  });
})
