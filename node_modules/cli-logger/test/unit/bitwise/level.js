var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should return lowest level of all streams', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR},
        {stream: process.stdout, level: logger.BW_INFO}
      ]
    };
    var log = logger(conf, true);
    expect(log.level()).to.eql(logger.BW_INFO);
    done();
  });
  it('should return lowest level of all streams (none)', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR},
        {stream: process.stdout, level: logger.BW_NONE}
      ]
    };
    var log = logger(conf, true);
    expect(log.level()).to.eql(logger.BW_NONE);
    done();
  });
  it('should set level of all streams (level)', function(done) {
    var name = 'mock-level-logger';
    var level = logger.BW_INFO|logger.BW_TRACE;
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR|logger.BW_FATAL},
        {stream: process.stdout, level: logger.BW_WARN}
      ]
    };
    var log = logger(conf, true);
    log.level(level);
    expect(log.streams[0].level).to.eql(level);
    expect(log.streams[1].level).to.eql(level);
    done();
  });
  it('should throw error on string level', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR},
        {stream: process.stdout, level: logger.BW_WARN}
      ]
    };
    var log = logger(conf, true);
    function fn() {
      log.level('info');
    }
    expect(fn).throws(Error);
    done();
  });
  it('should throw error on undefined level', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR},
        {stream: process.stdout, level: logger.BW_WARN}
      ]
    };
    var log = logger(conf, true);
    function fn() {
      log.level(undefined);
    }
    expect(fn).throws(Error);
    done();
  });
})
