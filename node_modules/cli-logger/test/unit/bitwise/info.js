var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should log info message (bitwise)', function(done) {
    var msg = 'mock info message';
    var name = 'mock-info-logger';
    var conf = {name: name, level: logger.BW_INFO};
    var log = logger(conf, true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    expect(log.info()).to.eql(true);
    log.info(msg);
  });
  it('should ignore info with error|trace level (bitwise)', function(done) {
    var name = 'mock-info-logger';
    var conf = {name: name, level: logger.BW_ERROR|logger.BW_TRACE};
    var log = logger(conf, true);
    expect(log.info()).to.eql(false);
    log.info('mock %s message to ignore', 'info');
    done();
  });
  it('should ignore info with none level (bitwise)', function(done) {
    var name = 'mock-info-logger';
    var conf = {name: name, level: logger.BW_NONE};
    var log = logger(conf, true);
    expect(log.info()).to.eql(false);
    log.info('mock %s message to ignore', 'info');
    done();
  });
})
