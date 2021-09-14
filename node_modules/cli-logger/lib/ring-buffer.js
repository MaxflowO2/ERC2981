var EventEmitter = require('events').EventEmitter;
var fs = require('fs');
var util = require('util');
var circular = require('circular');

/**
 *  Creates a RingBuffer instance.
 *
 *  @param options The stream configuration options.
 */
var RingBuffer = function(options) {
  EventEmitter.apply(this, arguments);
  options = options || {};
  this.limit = options.limit || 16;
  this.json = options.json || false;
  this.records = options.records || [];
}

util.inherits(RingBuffer, EventEmitter);

/**
 *  Write to the underlying records array.
 *
 *  @param record The log record.
 */
RingBuffer.prototype.write = function(record) {
  this.records.push(record);
  if(this.records.length > this.limit) {
    this.records.shift();
  }
}

/**
 *  Flush log records to a stream or file.
 *
 *  If you specify a string path the stream is destroyed after
 *  flushing the log records to the file otherwise you should
 *  clean up the write stream after calling this method.
 *
 *  If write stream options are not specified the *w* flags are used.
 *
 *  This implementation proxies any error event emitted by the stream,
 *  you should listen for error on the ring buffer instance.
 *
 *  @param stream A file system path or existing stream.
 *  @param options Options to pass when creating the write
 *  stream from a path.
 *
 *  @return The stream.
 */
RingBuffer.prototype.flush = function(stream, options) {
  var opened = false, scope = this;
  options = options || {
    flags: 'w',
    encoding: 'utf8'
  }
  if(typeof stream === 'string') {
    stream = fs.createWriteStream(stream, options);
    opened = true;
  }
  stream.on('error', function(e) {
    scope.emit('error', e);
  })
  var record;
  while((record = this.records.shift())) {
    if(this.json) {
      record = JSON.stringify(record, circular());
    }
    try {
      if(typeof record === 'string') {
        stream.write(record + '\n');
      }else{
        stream.write(record.msg + '\n');
      }
    }catch(e) {
      return stream;
    }
  }
  if(opened) stream.destroy();
  return stream;
}

module.exports = RingBuffer;
