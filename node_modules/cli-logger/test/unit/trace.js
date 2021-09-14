var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should log trace message', function(done) {
    var msg = 'mock trace message';
    var name = 'mock-trace-logger';
    var conf = {name: name, level: logger.TRACE};
    var log = logger(conf);
    expect(log.trace()).to.eql(true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    log.trace(msg);
  });
  it('should ignore trace with info level', function(done) {
    var name = 'mock-trace-logger';
    var conf = {name: name};
    var log = logger(conf);
    expect(log.trace()).to.eql(false);
    log.trace('mock %s message to ignore', 'trace');
    done();
  });
})
