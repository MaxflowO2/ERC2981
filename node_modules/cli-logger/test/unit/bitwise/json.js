var expect = require('chai').expect;
var logger = require('../../..');

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
  it('should translate json level to normal level (info)', function(done) {
    var msg = 'mock json info message';
    var name = 'mock-json-logger';
    var conf = {name: name, json: true,
      streams: {stream: process.stderr, level: logger.BW_INFO}
    };
    var log = logger(conf, true);
    process.stderr.write = function(message) {
      var str = message.trim();
      var record = JSON.parse(str);
      expect(record.msg).to.eql(msg);
      expect(record.level).to.eql(logger.INFO);
      done();
    }
    log.info(msg);
  });
  it('should translate json level to normal level (error)', function(done) {
    var msg = 'mock json info message';
    var name = 'mock-json-logger';
    var conf = {name: name, json: true,
      streams: {stream: process.stderr, level: logger.BW_ERROR}
    };
    var log = logger(conf, true);
    process.stderr.write = function(message) {
      var str = message.trim();
      var record = JSON.parse(str);
      expect(record.msg).to.eql(msg);
      expect(record.level).to.eql(logger.ERROR);
      done();
    }
    log.error(msg);
  });
})
