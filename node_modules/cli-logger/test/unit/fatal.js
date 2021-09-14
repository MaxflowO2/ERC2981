var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should log fatal message', function(done) {
    var msg = 'mock fatal message';
    var name = 'mock-fatal-logger';
    var conf = {name: name, level: logger.FATAL};
    var log = logger(conf);
    expect(log.fatal()).to.eql(true);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    log.fatal(msg);
  });
  it('should ignore fatal with none level', function(done) {
    var name = 'mock-fatal-logger';
    var conf = {name: name, level: logger.NONE};
    var log = logger(conf);
    expect(log.fatal()).to.eql(false);
    log.fatal('mock %s message to ignore', 'fatal');
    done();
  });
})
