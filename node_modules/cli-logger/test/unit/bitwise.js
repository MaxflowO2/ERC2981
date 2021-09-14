var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should configure bitwise levels', function(done) {
    var log = logger(null, true);
    expect(logger.bitwise.none)
      .to.eql(logger.BW_NONE)
      .to.eql(log.NONE).to.eql(0);
    expect(logger.bitwise.trace)
      .to.eql(logger.BW_TRACE)
      .to.eql(log.TRACE).to.eql(1);
    expect(logger.bitwise.debug)
      .to.eql(logger.BW_DEBUG)
      .to.eql(log.DEBUG).to.eql(2);
    expect(logger.bitwise.info)
      .to.eql(logger.BW_INFO)
      .to.eql(log.INFO).to.eql(4);
    expect(logger.bitwise.warn)
      .to.eql(logger.BW_WARN)
      .to.eql(log.WARN).to.eql(8);
    expect(logger.bitwise.error)
      .to.eql(logger.BW_ERROR)
      .to.eql(log.ERROR).to.eql(16);
    expect(logger.bitwise.fatal)
      .to.eql(logger.BW_FATAL)
      .to.eql(log.FATAL).to.eql(32);
    expect(logger.bitwise.all)
      .to.eql(logger.BW_ALL)
      .to.eql(log.ALL).to.eql(63);
    done();
  });
  it('should restore levels', function(done) {
    var log = logger(null, false);
    expect(logger.levels.trace)
      .to.eql(logger.TRACE)
      .to.eql(log.TRACE).to.eql(10);
    expect(logger.levels.debug)
      .to.eql(logger.DEBUG)
      .to.eql(log.DEBUG).to.eql(20);
    expect(logger.levels.info)
      .to.eql(logger.INFO)
      .to.eql(log.INFO).to.eql(30);
    expect(logger.levels.warn)
      .to.eql(logger.WARN)
      .to.eql(log.WARN).to.eql(40);
    expect(logger.levels.error)
      .to.eql(logger.ERROR)
      .to.eql(log.ERROR).to.eql(50);
    expect(logger.levels.fatal)
      .to.eql(logger.FATAL)
      .to.eql(log.FATAL).to.eql(60);
    expect(logger.levels.none)
      .to.eql(logger.NONE)
      .to.eql(log.NONE).to.eql(70);
    expect(logger.levels.all)
      .to.eql(logger.ALL).to.eql(undefined);
    done();
  });
})
