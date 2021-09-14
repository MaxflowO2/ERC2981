var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  var method;
  beforeEach(function(done) {
    method = console.info;
    done();
  })
  afterEach(function(done) {
    console.info = method;
    done();
  })
  it('should use console stream', function(done) {
    var name = 'mock-console-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var conf = {
      name: name, stream: new logger.ConsoleStream(), level: logger.INFO};
    console.info = function(message) {
      expect(arguments.length).to.eql(2);
      expect(message).to.eql(msg);
      expect(arguments[1]).to.eql(param);
      done();
    }
    var log = logger(conf);
    log.info(msg, param);
  });
  it('should write to console stream (invalid level code path)', function(done) {
    var name = 'mock-console-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var conf = {
      name: name, stream: new logger.ConsoleStream(), level: logger.INFO};
    var log = logger(conf);
    log.streams[0].stream.write({level: 1024});
    done();
  });
})
