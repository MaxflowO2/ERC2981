var Writable = require('stream').Writable;
var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should throw error on invalid stream property', function(done) {
    var name = 'mock-stdout-logger';
    var conf = {name: name, streams: {stream: true}};
    function fn() {
      var log = logger(conf);
    }
    expect(fn).throws(Error);
    done();
  });
  it('should throw error on invalid flags', function(done) {
    var name = 'mock-error-logger';
    var conf = {name: name, streams: [{path: 'log/mock-error.log', flags: 'z'}]};
    function fn() {
      var log = logger(conf);
    }
    expect(fn).throws(Error);
    done();
  });
  it('should throw error on invalid streams', function(done) {
    var name = 'mock-stderr-logger';
    var conf = {name: name, streams: true};
    function fn() {
      var log = logger(conf);
    }
    expect(fn).throws(Error);
    done();
  });
  it('should throw error on invalid flags', function(done) {
    var name = 'mock-error-logger';
    var conf = {name: name, streams: [{path: 'log/mock-error.log'}]};
    var log = logger(conf);
    log.on('error', function(e, stream) {
      expect(e).to.be.an.instanceof(Error);
      expect(stream).to.be.an.instanceof(Writable);
      done();
    })
    log.streams[0].stream.end();
    log.info('some mock data');
  });
  it('should throw error on unknown log level (string)', function(done) {
    var name = 'mock-stderr-logger';
    var conf = {name: name, streams: {level: 'unknown'}};
    function fn() {
      var log = logger(conf);
    }
    expect(fn).throws(Error);
    expect(fn).throws(/Unknown log level/);
    done();
  });
  it('should throw error on unknown log level (number)', function(done) {
    var name = 'mock-stderr-logger';
    var conf = {name: name, streams: {level: 1024}};
    function fn() {
      var log = logger(conf);
    }
    expect(fn).throws(Error);
    expect(fn).throws(/Unknown log level/);
    done();
  });
})
