var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  var method;
  beforeEach(function(done) {
    method = process.stderr.write;
    done();
  })
  afterEach(function(done) {
    process.stderr.write = method;
    done();
  })
  it('should log info message (json stringify code path)', function(done) {
    var msg = 'mock json info message';
    var name = 'mock-json-logger';
    var conf = {name: name, json: true, streams: {stream: process.stderr}};
    var log = logger(conf);
    process.stderr.write = function(message) {
      var str = message.trim();
      var record = JSON.parse(str);
      expect(record.msg).to.eql(msg);
      done();
    }
    log.info(msg);
  });
  it('should log info message createLogger (json stream stringify)',
    function(done) {
      var msg = 'mock json info message';
      var name = 'mock-json-logger';
      var conf = {name: name, streams: {stream: process.stderr}};
      var log = logger.createLogger(conf);
      process.stderr.write = function(message) {
        var str = message.trim();
        var record = JSON.parse(str);
        expect(record.msg).to.eql(msg);
        done();
      }
      log.info(msg);
    }
  );
  it('should log info message createLogger+json (json stream stringify)',
    function(done) {
      var msg = 'mock json info message';
      var name = 'mock-json-logger';
      var conf = {name: name, streams: {stream: process.stderr}, json: true};
      var log = logger.createLogger(conf);
      process.stderr.write = function(message) {
        var str = message.trim();
        var record = JSON.parse(str);
        expect(record.msg).to.eql(msg);
        done();
      }
      log.info(msg);
    }
  );
  it('should log info message createLogger-conf (json stream stringify)',
    function(done) {
      var msg = 'mock json info message';
      var log = logger.createLogger();
      log.on('write', function(record) {
        expect(record.msg).to.eql(msg);
        done();
      });
      log.info(msg);
    }
  );
  it('should log info message (json stringify circular reference)',
    function(done) {
      var msg = 'mock json info message';
      var name = 'mock-json-logger';
      var conf = {name: name, streams: {stream: process.stderr, json: true}};
      var log = logger(conf);
      var a = {};
      var b = {a: a}
      a.b = b;
      var obj = {a: a};
      process.stderr.write = function(message) {
        var str = message.trim();
        var record = JSON.parse(str);
        expect(record.msg).to.eql(msg);
        expect(record.a.b.a).to.eql('[Circular]');
        done();
      }
      log.info(obj, msg);
    }
  );
})
