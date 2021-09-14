var expect = require('chai').expect;
var logger = require('../../..');
process.stdout.setMaxListeners(128);
process.stderr.setMaxListeners(128);

describe('cli-logger:', function() {
  it('should log debug message (bitwise)', function(done) {
    var msg = 'mock debug message';
    var name = 'mock-debug-logger';
    var conf = {name: name, level: logger.BW_ALL};
    var log = logger(conf, true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    expect(log.trace()).to.eql(true);
    expect(log.debug()).to.eql(true);
    expect(log.info()).to.eql(true);
    expect(log.warn()).to.eql(true);
    expect(log.error()).to.eql(true);
    expect(log.fatal()).to.eql(true);
    log.debug(msg);
  });
  it('should ignore debug with all^debug level (bitwise)', function(done) {
    var name = 'mock-debug-logger';
    var conf = {name: name, level: logger.BW_ALL^logger.BW_DEBUG};
    var log = logger(conf, true);
    expect(log.debug()).to.eql(false);
    log.debug('mock %s message to ignore', 'debug');
    done();
  });
})
