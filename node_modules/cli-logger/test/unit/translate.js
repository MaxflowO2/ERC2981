var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should return normal mode log level untouched', function(done) {
    var log = logger();
    var level = log.translate(logger.INFO);
    logger.keys.forEach(function(key) {
      expect(log.translate(logger.levels[key])).to.eql(logger.levels[key]);
    })
    done();
  });
})
