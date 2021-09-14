var util = require('util');
var expect = require('chai').expect;
var logger = require('../../..');

describe('cli-logger:', function() {
  it('should serialize empty res property', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {res: logger.serializers.res};
    var obj = {
      res: {}
    }
    var conf = {
      name: name,
      level: logger.INFO,
      serializers: serializers
    };
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(expected);
      expect(record.res).to.eql(obj.res);
      done();
    })
    log.info(obj, msg, param);
  });
  it('should serialize res property', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {res: logger.serializers.res};
    var obj = {
      res: {
        statusCode: 200,
        _header: {
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
      expect(record.res.httpVersion).to.eql(undefined);
      expect(record.res.statusCode).to.eql(obj.res.statusCode);
      expect(record.res.header).to.eql(obj.res._header);
      done();
    })
    log.info(obj, msg, param);
  });
})
