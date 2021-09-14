var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should log fatal message (bitwise)', function(done) {
    var msg = 'mock fatal message';
    var name = 'mock-fatal-logger';
    var conf = {name: name, level: logger.BW_FATAL};
    var log = logger(conf, true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    expect(log.fatal()).to.eql(true);
    log.fatal(msg);
  });
  it('should ignore fatal with trace level (bitwise)', function(done) {
    var name = 'mock-fatal-logger';
    var conf = {name: name, level: logger.BW_TRACE};
    var log = logger(conf, true);
    expect(log.fatal()).to.eql(false);
    log.fatal('mock %s message to ignore', 'fatal');
    done();
  });
})
