var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should configure logger (stderr stream property)', function(done) {
    var name = 'mock-stdout-logger';
    var conf = {name: name, stream: process.stderr, level: logger.FATAL};
    var log = logger(conf);
    expect(log.streams[0].stream).to.equal(process.stderr);
    expect(log.streams[0].level).to.equal(logger.FATAL);
    done();
  });
  it('should configure logger (stdout stream)', function(done) {
    var name = 'mock-stdout-logger';
    var conf = {name: name, streams: [{stream: process.stdout}]};
    var log = logger(conf);
    expect(log.streams[0].stream).to.equal(process.stdout);
    done();
  });
  it('should configure logger (stderr stream)', function(done) {
    var name = 'mock-stderr-logger';
    var conf = {name: name, streams: [{stream: process.stderr}]};
    var log = logger(conf);
    expect(log.streams[0].stream).to.equal(process.stderr);
    done();
  });
  it('should configure logger (stderr stream property)', function(done) {
    var name = 'mock-stderr-logger';
    var conf = {name: name, streams: {stream: process.stderr}};
    var log = logger(conf);
    expect(log.streams[0].stream).to.equal(process.stderr);
    done();
  });
  it('should configure logger (stream json property)', function(done) {
    var name = 'mock-stderr-logger';
    var conf = {name: name, streams: {stream: process.stderr, json: true}};
    var log = logger(conf);
    expect(log.streams[0].json).to.eql(true);
    done();
  });
  it('should throw error on unknown stream type', function(done) {
    var name = 'mock-unknown-type-logger';
    var conf = {name: name, streams: {stream: process.stderr, type: 'unknown'}};
    function fn() {
      var log = logger(conf);
    }
    expect(fn).throws(Error);
    done();
  });
})
