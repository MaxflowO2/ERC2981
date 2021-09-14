var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should throw error on unknown stream index', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.INFO}
      ]
    };
    var log = logger(conf);
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
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.INFO}
      ]
    };
    var log = logger(conf);
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
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.INFO}
      ]
    };
    var log = logger(conf);
    var res = log.levels();
    expect(res).to.eql([logger.ERROR, logger.INFO])
    done();
  });
  it('should set stream level at index', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.INFO}
      ]
    };
    var log = logger(conf);
    log.levels(0, logger.INFO);
    var res = log.levels();
    expect(res).to.eql([logger.INFO, logger.INFO])
    done();
  });
  it('should set stream level at index by name', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR},
        {stream: process.stdout, level: logger.INFO}
      ]
    };
    var log = logger(conf);
    log.levels(0, 'info');
    var res = log.levels();
    expect(res).to.eql([logger.INFO, logger.INFO])
    done();
  });
  it('should get stream level by name', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR, name: 'stderr'},
        {stream: process.stdout, level: logger.INFO, name: 'stdout'}
      ]
    };
    var log = logger(conf);
    var level = log.levels('stderr');
    expect(level).to.eql(logger.ERROR);
    done();
  });
  it('should set stream level by name', function(done) {
    var name = 'mock-level-logger';
    var conf = {name: name,
      streams: [
        {stream: process.stderr, level: logger.ERROR, name: 'stderr'},
        {stream: process.stdout, level: logger.INFO, name: 'stdout'}
      ]
    };
    var log = logger(conf);
    log.levels('stderr', logger.INFO);
    var res = log.levels();
    expect(res).to.eql([logger.INFO, logger.INFO])
    done();
  });
})
