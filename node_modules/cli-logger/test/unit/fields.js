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
  it('should add configuration field to log record', function(done) {
    var msg = 'mock json info message';
    var name = 'mock-json-logger';
    var conf = {name: name, json: true,
      streams: {stream: process.stderr},
      type: 'mock-logger',
      component: 'test-suite'
    };
    var log = logger(conf);
    process.stderr.write = function(message) {
      var str = message.trim();
      var record = JSON.parse(str);
      expect(record.msg).to.eql(msg);
      expect(record.type).to.eql(conf.type);
      expect(record.component).to.eql(conf.component);
      done();
    }
    log.info(msg);
  });
})
