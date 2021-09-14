var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should log info message', function(done) {
    var msg = 'mock info message';
    var name = 'mock-info-logger';
    var conf = {name: name, level: 'info'};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    expect(log.info()).to.eql(true);
    log.info(msg);
  });
  it('should log info message (json)', function(done) {
    var msg = 'mock info message';
    var name = 'mock-info-logger';
    var conf = {name: name, json: true};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record).to.be.an('object');
      expect(record.msg).to.eql(msg);
      done();
    })
    log.info(msg);
  });
  it('should log info message with parameters (json)', function(done) {
    var expected = 'mock info message';
    var name = 'mock-info-logger';
    var conf = {name: name, json: true};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record).to.be.an('object');
      expect(record.msg).to.eql(expected);
      done();
    })
    log.info('mock %s message', 'info');
  });
  it('should ignore info with error level', function(done) {
    var name = 'mock-info-logger';
    var conf = {name: name, level: logger.ERROR};
    var log = logger(conf);
    expect(log.info()).to.eql(false);
    log.info('mock %s message to ignore', 'info');
    done();
  });
})
