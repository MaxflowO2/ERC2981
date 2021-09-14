var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should listen for write event', function(done) {
    var msg = 'mock write info';
    var name = 'mock-write-logger';
    var conf = {name: name, json: true, streams: [{path: 'log/mock-write.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.pid).to.be.a('number');
      expect(record.hostname).to.be.a('string');
      expect(record.time).to.be.a('string');
      expect(record.msg).to.eql(msg);
      expect(record.level).to.eql(logger.INFO);
      done();
    })
    log.info(msg);
  });
  it('should listen for write event with error instance', function(done) {
    var msg = 'mock write info';
    var name = 'mock-write-logger';
    var conf = {name: name, json: true, streams: [{path: 'log/mock-write.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      expect(record.err.message).to.eql(msg);
      expect(record.err.name).to.eql('Error');
      expect(record.err.stack).to.be.a('string');
      done();
    })
    log.info(new Error(msg));
  });
  it('should write error with custom message', function(done) {
    var msg = 'mock write %s';
    var parameters = ['info'];
    var expected = 'mock write info';
    var name = 'mock-write-logger';
    var conf = {name: name, json: true, streams: [{path: 'log/mock-write.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(expected);
      expect(record.err.message).to.eql('boom');
      done();
    })
    log.info(new Error('boom'), msg, parameters[0]);
  });
})
