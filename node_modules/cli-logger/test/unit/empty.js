var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  it('should handle empty message', function(done) {
    var log = logger();
    var res = log.log();
    expect(res).to.eql(false);
    expect(log.log(logger.INFO)).to.eql(true);
    done();
  });
})
