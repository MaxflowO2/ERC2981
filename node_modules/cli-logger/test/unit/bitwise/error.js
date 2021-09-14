var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should log error message (bitwise)', function(done) {
    var msg = 'mock error message';
    var name = 'mock-error-logger';
    var conf = {name: name, level: logger.BW_ERROR};
    var log = logger(conf, true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    expect(log.error()).to.eql(true);
    log.error(msg);
  });
  it('should ignore error with trace level (bitwise)', function(done) {
    var name = 'mock-error-logger';
    var conf = {name: name, level: logger.BW_TRACE};
    var log = logger(conf, true);
    expect(log.error()).to.eql(false);
    log.error('mock %s message to ignore', 'error');
    done();
  });
})
