var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should decorate json with properties', function(done) {
    var name = 'mock-object-logger';
    var conf = {name: name, json: true, streams: [{path: 'log/mock-write.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.req).to.be.an('object');
      expect(record.req.path).to.eql('/');
      done();
    })
    log.info({req: {path: '/'}});
  });
  it('should decorate json with properties (message)', function(done) {
    var msg = 'mock info message';
    var name = 'mock-object-logger';
    var conf = {name: name, json: true, streams: [{path: 'log/mock-write.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      expect(record.req).to.be.an('object');
      expect(record.req.path).to.eql('/');
      done();
    })
    log.info({req: {path: '/'}}, msg);
  });
  it('should decorate json with properties (message+parameters)', function(done) {
    var expected = 'mock info message';
    var name = 'mock-object-logger';
    var conf = {name: name, json: true, streams: [{path: 'log/mock-write.log'}]};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(expected);
      expect(record.req).to.be.an('object');
      expect(record.req.path).to.eql('/');
      done();
    })
    log.info({req: {path: '/'}}, 'mock %s message', 'info');
  });

  it('should stringify an object if no message provided (json false)',
    function (done) {
      var expected = '{"req":{"path":"/"}}';
      var name = 'mock-object-logger';
      var conf = {name: name, json: false, streams: [{path: 'log/mock-write.log'}]};
      var log = logger(conf);
      log.on('write', function(record, stream) {
        expect(record.msg).to.eql(expected);
        expect(record.req).to.be.an('object');
        expect(record.req.path).to.eql('/');
        done();
      })
      log.info({req: {path: '/'}});
    }
  );

  it('should use the empty string if no message provided (json true)',
    function (done) {
      var expected = '';
      var name = 'mock-object-logger';
      var conf = {name: name, json: true, streams: [{path: 'log/mock-write.log'}]};
      var log = logger(conf);
      log.on('write', function(record, stream) {
        expect(record.msg).to.eql(expected);
        expect(record.req).to.be.an('object');
        expect(record.req.path).to.eql('/');
        done();
      })
      log.info({req: {path: '/'}});
    }
  );
})
