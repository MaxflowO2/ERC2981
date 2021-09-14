var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should capture source information', function(done) {
    var msg = 'mock src info';
    var name = 'mock-src-logger';
    var conf = {name: name, json: true, src: true,
      streams: [{path: 'log/mock-src.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.src).to.be.an('object');
      expect(record.src.line).to.be.a('number');
      expect(record.src.stack).to.eql(undefined);
      expect(record.src.file).to.eql(__filename);
      done();
    })
    log.info(msg);
  });
  it('should capture source information in function', function(done) {
    var msg = 'mock src function info';
    var name = 'mock-src-logger';
    var conf = {name: name, json: true, src: true,
      streams: [{path: 'log/mock-src.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.src).to.be.an('object');
      expect(record.src.line).to.be.a('number');
      expect(record.src.stack).to.eql(undefined);
      expect(record.src.file).to.eql(__filename);
      done();
    })
    function fn() {
      log.info(msg);
    }
    fn();
  });
  it('should capture source information with stacktrace', function(done) {
    var msg = 'mock src info';
    var name = 'mock-src-logger';
    var conf = {name: name, json: true, src: true, stack: true,
      streams: [{path: 'log/mock-src.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.src).to.be.an('object');
      expect(record.src.line).to.be.a('number');
      expect(record.src.stack).to.be.an('array');
      expect(record.src.file).to.eql(__filename);
      done();
    })
    log.info(msg);
  });
})
