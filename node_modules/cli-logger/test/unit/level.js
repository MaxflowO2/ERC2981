var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should throw error on unknown log level (string)', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.INFO}
      ]
    };
    var log = logger(conf);
    function fn() {
      log.level('unknown');
    }
    expect(fn).throws(Error);
    done();
  });
  it('should throw error on unknown log level (number)', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.INFO}
      ]
    };
    var log = logger(conf);
    function fn() {
      log.level(1024);
    }
    expect(fn).throws(Error);
    done();
  });
  it('should return lowest level of all streams', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.INFO}
      ]
    };
    var log = logger(conf);
    expect(log.level()).to.eql(logger.INFO);
    done();
  });
  it('should set level of all streams (level)', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.WARN}
      ]
    };
    var log = logger(conf);
    log.level(logger.INFO);
    expect(log.streams[0].level).to.eql(logger.INFO);
    expect(log.streams[1].level).to.eql(logger.INFO);
    done();
  });
  it('should set level of all streams (string)', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.WARN}
      ]
    };
    var log = logger(conf);
    log.level('info');
    expect(log.streams[0].level).to.eql(logger.INFO);
    expect(log.streams[1].level).to.eql(logger.INFO);
    done();
  });
})
