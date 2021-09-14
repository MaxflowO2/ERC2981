var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should prepend message prefix', function(done) {
    var msg = 'mock info message';
    var name = 'mock-info-logger';
    var expected = name + ': ' + msg;
    var conf = {name: name, level: 'info'};
    conf.prefix = function(record) {
      return this.name + ': ';
    }
    var log = logger(conf);
    log.on('write', function(record, stream) {
      expect(record.msg).to.eql(expected);
      done();
    })
    log.info(msg);
  });
})
