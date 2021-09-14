var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should use default format function', function(done) {
    var msg = 'mock format message';
    var name = 'mock-format-logger';
    var conf = {name: name, level: 'info'};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg);
      done();
    })
    expect(log.info()).to.eql(true);
    log.info(msg);
  });
  it('should use named format function (capitalize)', function(done) {
    var msg = 'mock format message';
    var name = 'mock-format-logger';
    var conf = {name: name, level: 'info', formatter: 'capitalize'};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql('Mock format message');
      done();
    })
    expect(log.info()).to.eql(true);
    log.info(msg);
  });
  it('should use named format function (pedantic)', function(done) {
    var msg = 'mock format message';
    var name = 'mock-format-logger';
    var conf = {name: name, level: 'info', formatter: 'pedantic'};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql('mock format message.');
      done();
    })
    expect(log.info()).to.eql(true);
    log.info(msg);
  });
  it('should use named format function (normalize)', function(done) {
    var msg = 'mock format message';
    var name = 'mock-format-logger';
    var conf = {name: name, level: 'info', formatter: 'normalize'};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql('Mock format message.');
      done();
    })
    expect(log.info()).to.eql(true);
    log.info(msg);
  });
  it('should use custom format function', function(done) {
    var msg = 'mock format message';
    var name = 'mock-format-logger';
    function formatter(record, parameters, format) {
      var message = format(record, parameters);
      return message.split('').reverse().join('');
    }
    var conf = {name: name, level: 'info', formatter: formatter};
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(msg.split('').reverse().join(''));
      done();
    })
    expect(log.info()).to.eql(true);
    log.info(msg);
  });
  it('should use default format function (unknown string formatter)',
    function(done) {
      var msg = 'mock format message';
      var name = 'mock-format-logger';
      var conf = {name: name, level: 'info', formatter: 'invalid'};
      var log = logger(conf);
      log.on('write', function(record, stream) {
        expect(record.msg).to.eql(msg);
        done();
      })
      expect(log.info()).to.eql(true);
      log.info(msg);
    }
  );
})
