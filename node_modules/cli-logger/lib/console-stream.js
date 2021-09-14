var EventEmitter = require('events').EventEmitter;
var util = require('util')
  , utils = require('cli-util');

/**
 *  Creates a ConsoleStream instance.
 *
 *  @param options The stream configuration options.
 */
var ConsoleStream = function(options) {
  EventEmitter.apply(this, arguments);
  this.options = options || {};
}

util.inherits(ConsoleStream, EventEmitter);

/**
 *  Initialize writers based on the log configuration.
 *
 *  @param log The logger instance.
 */
ConsoleStream.prototype.logger = function(log) {
  var writers = this.options.writers || log.conf.writers || {};
  if(typeof writers === 'function') {
    var writer = writers;
    writers = {};
    log.keys.forEach(function(method) {
      writers[method] = writer;
    })
  }
  this.writers = {};
  this.writers[log.TRACE] = writers.trace || console.log;
  this.writers[log.DEBUG] = writers.debug || console.log;
  this.writers[log.INFO] = writers.info || console.info;
  this.writers[log.WARN] = writers.warn || console.warn;
  this.writers[log.ERROR] = writers.error || console.error;
  this.writers[log.FATAL] = writers.fatal || console.error;
}

function istty(lvl) {
  var ttycolor = global.ttycolor;
  //console.dir(ttycolor.stderr())

  if(ttycolor && ttycolor.mode === ttycolor.modes.always) {
    return true;
  }else if(ttycolor && ttycolor.mode === ttycolor.modes.never) {
    return false;
  }

  //console.log('console stream is tty: ' + lvl);
  var writer = this.writers[lvl];
  if((ttycolor && ttycolor.stderr())
    || (writer === console.error || writer === console.warn)) {
    return process.stderr.isTTY;
  }else if(writer === console.log || writer === console.info) {
    return process.stdout.isTTY;
  }else if(writer) {
    return writer.isTTY;
  }

  return false;
}

ConsoleStream.prototype.istty = istty;

ConsoleStream.prototype.prefix = function(prefix, msg, parameters) {
  if(prefix == '') {
    return {msg: msg, parameters: parameters};
  }
  if(parameters) parameters.unshift(prefix);
  return {msg: '%s ' + msg, parameters: parameters};
}

ConsoleStream.prototype.format = function(msg, parameters) {
  parameters = parameters || [];
  var ttycolor = global.ttycolor;
  var usetty = ttycolor && (ttycolor.revert !== undefined);
  if(usetty) {
    return ttycolor.format.apply(
      ttycolor, [msg].concat(parameters));
  }else{
    return util.format.apply(util, [msg].concat(parameters))
  }
}

/**
 *  Write to the underlying console method.
 *
 *  @param record The log record.
 */
ConsoleStream.prototype.write = function(
  record, prefix, message, parameters, trace) {

  var msg = message || record.message
    , parameters = (parameters || record.parameters || []).slice(0)
    , newline = utils.hasNewline(msg, parameters)
    , level = record.level, writer = this.writers[level]
    , i, res
    , scope = this
    , prefixer = this.prefix;

  // json log record
  if(typeof record === 'string') {
    // prefix becomes the level
    writer = this.writers[prefix];
    return println(record);
  }

  if(typeof prefix === 'function') {
    prefixer = prefix;
  }

  function println(msg, parameters) {
    if(!parameters) return writer.apply(console, [msg]);
    writer.apply(
      console, [msg].concat(parameters));
  }

  if(writer) {
    if(!prefix) {
      prefix = '';
    }

    if(newline) {
      msg = this.format(msg, parameters);
      var lines = msg.split('\n');
      lines.forEach(function(line) {
        res = prefixer(prefix, '' + line, null, record, true);
        if(prefixer !== scope.prefix) {
          println(res.msg, res.parameters);
        }else{
          println(
            res.msg,
            res.parameters ? res.parameters.unshift(prefix) : [prefix]);
        }
      })
    }else{
      res = prefixer(prefix, msg, parameters, record, false);
      println(res.msg, res.parameters);
    }
  }
}

module.exports = ConsoleStream;
