var util = require('util');
var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should serialize persistent field req property', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {req: logger.serializers.req};
    var conf = {
      name: name,
      level: logger.INFO,
      serializers: serializers,
      req: {}
    };
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(expected);
      expect(record.req).to.eql(conf.req);
      done();
    })
    log.info(msg, param);
  });
  it('should serialize empty req property', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {req: logger.serializers.req};
    var obj = {
      req: {}
    }
    var conf = {
      name: name,
      level: logger.INFO,
      serializers: serializers
    };
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(expected);
      expect(record.req).to.eql(obj.req);
      done();
    })
    log.info(obj, msg, param);
  });
  it('should serialize req property', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {req: logger.serializers.req};
    var obj = {
      req: {
        connection: {
          remoteAddress: '127.0.0.1',
          remotePort: 2048
        },
        method: 'GET',
        url: '/',
        headers: {
          'content-type': 'application/json'
        }
      }
    }
    var conf = {
      name: name,
      level: logger.INFO,
      serializers: serializers
    };
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(expected);
      expect(record.req.httpVersion).to.eql(undefined);
      expect(record.req.trailers).to.eql(undefined);
      expect(record.req.method).to.eql(obj.req.method);
      expect(record.req.url).to.eql(obj.req.url);
      expect(record.req.remoteAddress).to.eql(obj.req.connection.remoteAddress);
      expect(record.req.remotePort).to.eql(obj.req.connection.remotePort);
      expect(record.req.headers).to.eql(obj.req.headers);
      done();
    })
    log.info(obj, msg, param);
  });
})
