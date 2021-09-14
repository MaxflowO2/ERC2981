var fs = require('fs');
var path = require('path');
var expect = require('chai').expect;
var logger = require('../..');

describe('cli-logger:', function() {
  var method;
  beforeEach(function(done) {
    method = process.stderr.write;
    done();
  })
  afterEach(function(done) {
    process.stderr.write = method;
    done();
  })
  it('should create ring buffer', function(done) {
    var name = 'mock-ring-buffer-logger';
    var ringbuffer = new logger.RingBuffer();
    var conf = {
      name: name,
      streams: [
        {
          stream: ringbuffer,
          level: logger.TRACE
        }
      ]
    };
    var log = logger(conf);
    expect(log.streams[0].stream).to.eql(ringbuffer);
    expect(log.streams[0].type).to.eql(logger.RAW);
    expect(ringbuffer.limit).to.eql(16);
    expect(ringbuffer.records).to.eql([]);
    done();
  });
  it('should log to ring buffer records', function(done) {
    var name = 'mock-ring-buffer-logger';
    var ringbuffer = new logger.RingBuffer({limit: logger.keys.length});
    var conf = {
      name: name,
      streams: [
        {
          stream: ringbuffer,
          level: logger.TRACE
        }
      ]
    };
    var log = logger(conf);
    expect(ringbuffer.limit).to.eql(logger.keys.length);
    expect(ringbuffer.records).to.eql([]);
    logger.keys.forEach(function(method) {
      log[method]('mock %s message', method);
    })
    expect(ringbuffer.records.length)
      .to.eql(logger.keys.length)
      .to.eql(ringbuffer.limit);
    log.info('mock %s message', 'info');
    expect(ringbuffer.records.length)
      .to.eql(logger.keys.length)
      .to.eql(ringbuffer.limit);
    done();
  });
  it('should flush ring buffer records to stderr', function(done) {
    var name = 'mock-ring-buffer-logger';
    var ringbuffer = new logger.RingBuffer(
      {limit: logger.keys.length});
    process.stderr.write = function(chunk) {
      expect(chunk).to.eql('mock info message\n');
      done();
    }
    var conf = {
      name: name,
      streams: [
        {
          stream: ringbuffer,
          level: logger.TRACE
        }
      ]
    };
    var log = logger(conf);
    log.info('mock %s message', 'info');
    ringbuffer.flush(process.stderr);
    expect(ringbuffer.records.length).to.eql(0);
  });
  it('should flush ring buffer records to stderr (json)', function(done) {
    var name = 'mock-ring-buffer-logger';
    var ringbuffer = new logger.RingBuffer(
      {limit: logger.keys.length, json: true});
    process.stderr.write = function(chunk) {
      var record = JSON.parse(chunk);
      expect(record.msg).to.eql('mock info message');
      done();
    }
    var conf = {
      name: name,
      streams: [
        {
          stream: ringbuffer,
          level: logger.TRACE
        }
      ]
    };
    var log = logger(conf);
    log.info('mock %s message', 'info');
    ringbuffer.flush(process.stderr);
    expect(ringbuffer.records.length).to.eql(0);
  });
  it('should flush ring buffer records to file (json)', function(done) {
    var name = 'mock-ring-buffer-logger';
    var ringbuffer = new logger.RingBuffer(
      {limit: logger.keys.length, json: true});
    var conf = {
      name: name,
      streams: [
        {
          stream: ringbuffer,
          level: logger.TRACE
        }
      ]
    };
    var log = logger(conf);
    log.info('mock %s message', 'info');
    ringbuffer.flush(path.join('log', name + '.log'));
    expect(ringbuffer.records.length).to.eql(0);
    done();
  });

  // seems the behaviour of node changed re emitting an error event here

  //it('should emit error event on closed stream (json)', function(done) {
    //var name = 'mock-ring-buffer-logger';
    //var ringbuffer = new logger.RingBuffer(
      //{limit: logger.keys.length, json: true});
    //var conf = {
      //name: name,
      //streams: [
        //{
          //stream: ringbuffer,
          //level: logger.TRACE
        //}
      //]
    //};
    //ringbuffer.on('error', function(e) {
      //expect(e).to.be.instanceof(Error);
      //done();
    //})
    //var log = logger(conf);
    //log.info('mock %s message', 'info');
    //var stream = fs.createWriteStream(
      //path.join('log', name + '.log'), {flags: 'w'});
    //stream.end();
    //ringbuffer.flush(stream);
    //expect(ringbuffer.records.length).to.eql(0);
  //});
})
