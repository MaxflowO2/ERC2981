var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should log warn message (bitwise)', function(done) {
    var msg = 'mock warn message';
    var name = 'mock-warn-logger';
    var conf = {name: name, level: logger.BW_ALL};
    var log = logger(conf, true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    expect(log.warn()).to.eql(true);
    log.warn(msg);
  });
  it('should ignore warn with trace level (bitwise)', function(done) {
    var name = 'mock-warn-logger';
    var conf = {name: name, level: logger.BW_TRACE};
    var log = logger(conf, true);
    expect(log.warn()).to.eql(false);
    log.warn('mock %s message to ignore', 'warn');
    done();
  });
})
