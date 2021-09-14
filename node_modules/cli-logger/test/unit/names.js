var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should retrieve string name for normal log levels', function(done) {
    var log = logger();
    var names = [];
    logger.keys.forEach(function(key) {
      var level = logger.levels[key];
      names.push(log.names(level));
    })
    expect(names).to.eql(logger.keys);
    done();
  });
  it('should retrieve string name for bitwise log levels', function(done) {
    var log = logger();
    var names = [];
    logger.keys.forEach(function(key) {
      var level = logger.bitwise[key];
      names.push(log.names(level));
    })
    expect(names).to.eql(logger.keys);
    done();
  });
  it('should return level untouched', function(done) {
    var log = logger();
    var name = log.names(1024);
    expect(name).to.eql(1024);
    done();
  });
  it('should retrieve array of names for complex bitwise log levels',
    function(done) {
      var log = logger();
      var level = logger.BW_ALL^logger.BW_TRACE^logger.BW_DEBUG
      var names = log.names(level, true);
      //console.dir(names);
      expect(names).to.eql(logger.keys.slice(2));
      done();
    }
  );
})
