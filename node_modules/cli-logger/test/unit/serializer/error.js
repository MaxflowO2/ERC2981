var util = require('util');
var expect = require('chai').expect;
var logger = require('../../..');
var CliError = require('cli-error').CliError;

describe('cli-logger:', function() {
  it('should serialize empty err property', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {err: logger.serializers.err};
    var obj = {
      err: {}
    }
    var conf = {
      name: name,
      level: logger.INFO,
      serializers: serializers
    };
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(expected);
      expect(record.err).to.eql(obj.err);
      done();
    })
    log.info(obj, msg, param);
  });
  it('should serialize err property', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {err: logger.serializers.err};
    var obj = {
      err: new Error('Mock simple error')
    }
    var conf = {
      name: name,
      level: logger.INFO,
      serializers: serializers
    };
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.err.name).to.eql('Error');
      expect(record.err.message).to.eql('Mock simple error');
      expect(record.err.stack).to.be.a('string');
      expect(record.err.code).to.eql(undefined);
      expect(record.err.signal).to.eql(undefined);
      done();
    })
    log.info(obj, msg, param);
  });
  it('should serialize err with cause', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {err: logger.serializers.err};
    var e = new Error('Mock simple error');
    var err = new CliError(e);
    var obj = {
      err: err
    }
    var conf = {
      name: name,
      level: logger.INFO,
      serializers: serializers
    };
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.err.message).to.eql('Mock simple error');
      expect(record.err.stack).to.be.a('string');
      expect(record.err.code).to.eql(1);
      expect(record.err.signal).to.eql(undefined);
      done();
    })
    log.info(obj, msg, param);
  });
  it('should serialize err with null cause', function(done) {
    var name = 'mock-serialize-logger';
    var msg = 'mock %s message';
    var param = 'info';
    var expected = util.format(msg, param);
    var serializers = {err: logger.serializers.err};
    var err = new CliError('Mock simple error');
    var obj = {
      err: err
    }
    var conf = {
      name: name,
      level: logger.INFO,
      serializers: serializers
    };
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.err.message).to.eql('Mock simple error');
      expect(record.err.stack).to.be.a('string');
      expect(record.err.code).to.eql(1);
      expect(record.err.signal).to.eql(undefined);
      done();
    })
    log.info(obj, msg, param);
  });
})
