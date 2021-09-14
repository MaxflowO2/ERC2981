var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should log trace message (bitwise)', function(done) {
    var msg = 'mock trace message';
    var name = 'mock-trace-logger';
    var conf = {name: name, level: logger.BW_TRACE};
    var log = logger(conf, true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    expect(log.trace()).to.eql(true);
    log.trace(msg);
  });
  it('should ignore trace with all^trace level (bitwise)', function(done) {
    var name = 'mock-trace-logger';
    var conf = {name: name, level: logger.BW_ALL^logger.BW_TRACE};
    var log = logger(conf, true);
    expect(log.trace()).to.eql(false);
    log.trace('mock %s message to ignore', 'trace');
    done();
  });
})
