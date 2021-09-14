var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should throw error on unknown stream index', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR|logger.BW_FATAL},
        {stream: process.stdout, level: logger.BW_INFO}
      ]
    };
    var log = logger(conf, true);
    function fn() {
      log.levels(2);
    }
    expect(fn).throws(Error);
    done();
  });
  it('should throw error on unknown stream name', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR|logger.BW_FATAL},
        {stream: process.stdout, level: logger.BW_INFO}
      ]
    };
    var log = logger(conf, true);
    function fn() {
      log.levels('unknown');
    }
    expect(fn).throws(Error);
    done();
  });
  it('should get array of stream levels', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR|logger.BW_FATAL},
        {stream: process.stdout, level: logger.BW_INFO}
      ]
    };
    var log = logger(conf, true);
    var res = log.levels();
    expect(res).to.eql([logger.BW_ERROR|logger.BW_FATAL, logger.BW_INFO])
    done();
  });
  it('should set stream level at index', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR|logger.BW_FATAL},
        {stream: process.stdout, level: logger.BW_INFO}
      ]
    };
    var log = logger(conf, true);
    log.levels(0, logger.BW_INFO);
    var res = log.levels();
    expect(res).to.eql([logger.BW_INFO, logger.BW_INFO])
    done();
  });
  it('should set stream level at index by name', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR|logger.BW_FATAL},
        {stream: process.stdout, level: logger.BW_INFO}
      ]
    };
    var log = logger(conf, true);
    log.levels(0, 'info');
    var res = log.levels();
    expect(res).to.eql([logger.BW_INFO, logger.BW_INFO])
    done();
  });
  it('should get stream level by name', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR, name: 'stderr'},
        {stream: process.stdout, level: logger.BW_INFO, name: 'stdout'}
      ]
    };
    var log = logger(conf, true);
    var level = log.levels('stderr');
    expect(level).to.eql(logger.BW_ERROR);
    done();
  });
  it('should set stream level by name', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.BW_ERROR, name: 'stderr'},
        {stream: process.stdout, level: logger.BW_INFO, name: 'stdout'}
      ]
    };
    var log = logger(conf, true);
    log.levels('stderr', logger.BW_INFO);
    var res = log.levels();
    expect(res).to.eql([logger.BW_INFO, logger.BW_INFO])
    done();
  });
})
