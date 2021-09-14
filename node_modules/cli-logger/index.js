var EventEmitter = require('events').EventEmitter
  , fs = require('fs')
  , os = require('os')
  , path = require('path'), basename = path.basename
  , util = require('util')
  , circular = require('circular')
  , utils = require('cli-util')
  , pedantic = utils.pedantic
  , ucfirst = utils.ucfirst
  , merge = utils.merge;

var pkg = require(path.join(__dirname, 'package.json'));
var major = parseInt(pkg.version.split('.')[0]), z;

var RAW = 'raw';
var STREAM = 'stream';
var FILE = 'file';
var CONSOLE = 'console';

var LEVELS = {
  trace: 10,
  debug: 20,
  info: 30,
  warn: 40,
  error: 50,
  fatal: 60,
  none: 70
}

var BITWISE = {
  none: 0,
  trace: 1,
  debug: 2,
  info: 4,
  warn: 8,
  error: 16,
  fatal: 32,
  all: 63
}

var formatters = {
  pedantic: function(record, parameters, format) {
    var message = format(record, parameters);
    return pedantic(message, this.conf.pedantic || '.');
  },
  normalize: function(record, parameters, format) {
    var message = format(record, parameters);
    return ucfirst(pedantic(message, this.conf.pedantic || '.'));
  },
  capitalize: function(record, parameters, format) {
    var message = format(record, parameters);
    return ucfirst(message);
  },
}

var keys = Object.keys(LEVELS); keys.pop();
var types = [RAW, STREAM, FILE, CONSOLE];
var defaults = {
  name: basename(process.argv[1]),
  json: false,
  trace: true,
  src: false,
  hostname: null,
  pid: null,
  stack: false,
  console: false,
  serializers: null,
  prefix: null,
  writers: null,
  level: null,
  stream: null,
  streams: null
}

/**
 *  Create a Logger instance.
 *
 *  @param conf The logger configuration.
 *  @param bitwise A boolean indicating that log levels
 *  should use bitwise operators.
 *  @param parent A parent logger that owns this logger.
 */
var Logger = function(conf, bitwise, parent) {
  EventEmitter.call(this);
  conf = conf || {};
  constants(this);
  this.keys = keys;
  this.bitwise = (bitwise === true);
  this.configure();
  var cstreams = parent && conf.streams;
  var streams = conf.streams, stream = conf.stream;
  streams = streams || this.getDefaultStream(conf);
  delete conf.streams;
  delete conf.stream;
  var target = parent ? merge(parent.conf, {}) : merge(defaults, {});
  this.conf = merge(conf, target);
  if(typeof this.conf.name !== 'string' || !this.conf.name.length) {
    throw new Error('Logger name \'' + this.conf.name + '\' is invalid');
  }
  this.name = this.conf.name;
  conf.streams = streams;
  if(stream) conf.stream = stream;
  this.pid = this.conf.pid || process.pid;
  this.hostname = this.conf.hostname || os.hostname();
  this.fields = {};
  this.streams = [];
  if(parent && cstreams) {
    streams = Array.isArray(streams) ? streams : [streams];
    streams = streams.concat(conf.streams);
  }
  this.initialize(streams);
}

util.inherits(Logger, EventEmitter);

/**
 *  Retrieve the default stream when no streams have been configured.
 *
 *  @param conf The configuration object.
 */
Logger.prototype.getDefaultStream = function(conf) {
  var stream = conf.stream;
  if(conf.console && !(stream instanceof ConsoleStream)) {
    stream = new ConsoleStream({writers: conf.writers});
  }
  return {
    stream: stream || process.stdout
  }
}

Logger.prototype.useConsoleStream = function() {
  var stream = new ConsoleStream({writers: this.conf.writers});
  stream.logger(this);
  this.streams[0].stream = stream;
  this.streams[0].type = CONSOLE;
}

Logger.prototype.isDefault = function() {
  return this.streams.length === 1
    && this.streams[0].stream === process.stdout;
}

/**
 *  Configure instance log levels.
 *
 *  @api private
 */
Logger.prototype.configure = function() {
  this._levels = {}
  var target = this.bitwise ? BITWISE : LEVELS;
  for(var z in target) {
    this._levels[z] = target[z];
    this[z.toUpperCase()] = this._levels[z];
  }
}

/**
 *  Resolve a level string name to the corresponding
 *  integer value.
 *
 *  @api private
 *
 *  @param level A string or integer.
 *
 *  @return The level integer or undefined if a string value
 *  does not correspond to a known log level.
 */
Logger.prototype.resolve = function(level) {
  var msg = 'Unknown log level \'' + level + '\'';
  var key, value, z, exists = false;
  if(typeof(level) == 'string') {
    key = level.toLowerCase();
    level = this._levels[key];
  }
  if(!this.bitwise) {
    for(z in this._levels) {
      if(this._levels[z] === level) {
        exists = true;
        break;
      }
    }
    if(level === undefined || !exists) throw new Error(msg);
  }
  return level;
}

/**
 *  Initialize the output streams.
 *
 *  @api private
 */
Logger.prototype.initialize = function(source) {
  var i;
  if(source && typeof(source) == 'object' && !Array.isArray(source)) {
    this.convert(source);
  }else if(Array.isArray(source)) {
    for(i = 0;i < source.length;i++) {
      this.convert(source[i]);
    }
  }else{
    throw new Error('Invalid streams configuration');
  }
  // initialize custom data fields
  for(i in this.conf) {
    if(!defaults.hasOwnProperty(i)) {
      this.fields[i] = this.conf[i];
    }
  }
}

/**
 *  Append a stream.
 *
 *  @api private
 *
 *  @param source The stream configuration object.
 */
Logger.prototype.append = function(source) {
  var scope = this;
  var level = source.level, json = source.json, stream = source.stream;
  var lvl = this.bitwise ? (level === undefined ? this.conf.level : level)
    : level || this.conf.level || this._levels.info;
  var data = {
    stream: stream,
    level: scope.resolve(lvl),
    name: source.name,
    type: source.type
  }
  if(typeof json === 'boolean') data.json = json;
  this.streams.push(data);
  stream.removeAllListeners('error');
  stream.on('error', function(e) {
    scope.emit('error', e, stream);
  })
}

/**
 *  Convert a stream configuration object into a
 *  stream instance.
 *
 *  @api private
 *
 *  @param source The stream configuration object.
 */
Logger.prototype.convert = function(source) {
  var stream = source.stream, opts;
  source.type = source.type || STREAM;
  if(source.path) {
    source.type = FILE;
    opts = {
      flags: source.flags || 'a',
      mode: source.mode,
      encoding: source.encoding
    }
    try {
      source.stream = fs.createWriteStream(source.path, opts);
    }catch(e) {
      this.emit('error', e);
    }
  }
  if(!~types.indexOf(source.type)) {
    throw new Error('Unknown stream type \'' + source.type + '\'');
  }
  if(source.stream && !(source.stream instanceof EventEmitter)
    && typeof source.stream.write !== 'function') {
    throw new Error('Invalid stream specified');
  }
  if((source.stream instanceof RingBuffer)) {
    source.type = RAW;
  }else if((source.stream instanceof ConsoleStream)) {
    source.type = CONSOLE;
  }
  if(source.stream && typeof source.stream.logger === 'function') {
    source.stream.logger(this);
  }
  this.append(source);
}

/**
 *  Retrieve caller info, used when the src configuration
 *  property is true to determine the file and line number
 *  that the log call came from.
 *
 *  @api private
 *
 *  @see http://code.google.com/p/v8/wiki/JavaScriptStackTraceApi
 */
Logger.prototype.getCallerInfo = function() {
  var obj = {}, stacktrace = this.conf.stack;
  var limit = Error.stackTraceLimit;
  var prepare = Error.prepareStackTrace;
  Error.captureStackTrace(this, arguments.callee);
  Error.prepareStackTrace = function (_, stack) {
    var caller = stack[3];
    obj.file = caller.getFileName();
    obj.line = caller.getLineNumber();
    var func = caller.getFunctionName();
    if(func) obj.func = func;
    if(stacktrace) {
      obj.stack = stack.slice(3);
      obj.stack.forEach(function(caller, index, arr) {
        arr[index] = '' + caller;
      })
    }
    return stack;
  };
  var stack = this.stack;
  Error.prepareStackTrace = prepare;
  return obj;
}

/**
 *  Translate a bitwise log level to a normal mode
 *  log level.
 *
 *  @param level The bitwise log level.
 *
 *  @return A normal mode log level.
 */
Logger.prototype.translate = function(level) {
  for(var i = 0;i < keys.length;i++) {
    if(BITWISE[keys[i]] === level) {
      return LEVELS[keys[i]];
    }
  }
  return level;
}

/**
 *  Retrieve a log record.
 *
 *  @api private
 *
 *  @param level The log level.
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.getLogRecord = function(level, message) {
  var parameters = [].slice.call(arguments, 2)
    , z, e, k
    , record = {}
    , err = (message instanceof Error) ? message : null
    , clierr = err && typeof err.toStackArray === 'function';

  if(err) {
    e = {};
    for(k in err) {
      if(typeof err[k] === 'function' || /^_/.test(k)) continue;
      e[k] = err[k];
    }
    //console.log('is cli err %s', clierr);
    // array of stack trace lines is preferable
    if(err.stack) {
      e.stack = clierr ? err.toStackArray() : err.stack.split('\n');
    }
    record.err = e;
  }

  var obj = (!err && message && typeof(message) == 'object') ? message : null;
  if(err || obj) {
    message = arguments[2] || '';
    parameters = [].slice.call(arguments, 3);
  }
  if(err) {
    message = arguments[2] || err.message;
    parameters = (err.parameters || parameters || []).slice(0);
  }
  record.time = new Date().toISOString();
  for(z in this.fields) {
    record[z] = this.serialize(z, this.fields[z]);
  }
  if(obj) {
    for(z in obj) {
      record[z] = this.serialize(z, obj[z]);
    }
    if(arguments.length == 2) {
      message = !this.conf.json ? JSON.stringify(obj, circular()) : '';
    }
  }
  record.pid = this.pid;
  record.hostname = this.hostname;
  record.name = this.conf.name;
  record.msg = message;
  record.level = level;
  if(err && !clierr) {
    record.err = serializers.err.call(this, err);
  }
  if(this.conf.src) {
    record.src = this.getCallerInfo();
  }
  record.v = major;
  //console.dir(record);
  return {record: record, parameters: parameters};
}

/**
 *  Serialize a log record value when a serializer
 *  is available for the log record property name.
 *
 *  @api private
 *
 *  @param k The log record key.
 *  @param v The log record value.
 *
 *  @return The original value when no serializer is declared
 *  for the property or the result of invoking the serializer function.
 */
Logger.prototype.serialize = function(k, v) {
  var serializer = this.conf.serializers
    && (typeof this.conf.serializers[k] === 'function')
    ? this.conf.serializers[k] : null;
  if(!serializer) return v;
  return serializer.apply(this, [v]);
}

Logger.prototype.format = function(record, parameters) {
  var params = parameters.slice(0);
  params.unshift(record.msg);
  return util.format.apply(util, params);
}

/**
 *  Write the log record to stream(s) or dispatch
 *  the write event if there are listeners for the write
 *  event.
 *
 *  @api private
 *
 *  @param level The log level.
 *  @param record The log record.
 *  @param parameters Message replacement parameters.
 *  @param force Force write to the stream even if the level would
 *  disallow it.
 */
Logger.prototype.write = function(level, record, parameters, force) {
  var i, target, listeners = this.listeners('write'), json, params, event;
  var msg = '' + record.msg
    , prefix
    , conf = this.conf
    , formatter;
  parameters = parameters || [];
  level = level || record.level;
  params = parameters.slice(0);

  formatter = typeof conf.formatter === 'function' ? conf.formatter : null;
  if(!formatter) {
    formatter = formatter || typeof conf.formatter === 'string'
      ? formatters[conf.formatter] : null;
  }
  formatter = formatter || this.format;

  record.msg = formatter.call(this, record, params, this.format.bind(this));

  //console.error('writing %j', record);
  for(i = 0;i < this.streams.length;i++) {
    target = this.streams[i];
    if(typeof this.conf.prefix === 'function' && !prefix) {
      prefix = this.conf.prefix.apply(
        this, [
          record,
          target.type === RAW
            ? false
            : (target.type === CONSOLE
               ? target.stream.istty(level) : target.stream.isTTY)]);

      if(target.type !== CONSOLE) {
        record.msg = prefix + record.msg;
        msg = prefix + msg;
      }
    }
    json = (target.json === true) || this.conf.json;
    if(json && !listeners.length && (target.type !== RAW)) {
      if(this.bitwise) record.level = this.translate(record.level);
      json = JSON.stringify(record, circular());
    }
    if(force || this.enabled(level, target.level)) {
      if(listeners.length) {
        this.emit('write', record, target.stream, msg, parameters);
      }else{
        target.isConsole = (target.type === CONSOLE);
        target.isRaw = (target.type === RAW);
        this.emit('record', level, record, target, msg, parameters);
        event = record;
        if(typeof json === 'string') {
          target.stream.write(
            json + (target.isConsole ? '' : '\n'),
            target.isConsole ? level : null);
        }else if(target.type === CONSOLE) {
          record.message = msg;
          record.parameters = parameters;
          target.stream.write(record, prefix);
        }else if(target.type === RAW){
          target.stream.write(record);
        }else{
          target.stream.write(record.msg + '\n');
        }
        this.emit('flush', level, record, target, msg, parameters);
      }
    }
  }
  if(event) {
    this.emit('log', record, record.level, msg, parameters);
  }
  return (listeners.length === 0 && event !== undefined);
}

/**
 *  Log a message.
 *
 *  @api private
 *
 *  @param level The log level.
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.log = function(level, message) {
  if(!level) return false;
  if(level && !message) return this.enabled(level);
  var args = [].slice.call(arguments, 0);
  var info = this.getLogRecord.apply(this, args);
  //console.dir(info);
  return this.write(level, info.record, info.parameters);
}

/**
 *  Force print a message at the info level.
 *
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.print = function() {
  var level = this._levels.info;
  var args = [].slice.call(arguments, 0);
  if(typeof args[0] === 'object' && args[0].level) {
    level = args[0].level;
  }
  args.unshift(level);
  var info = this.getLogRecord.apply(this, args);
  return this.write(level, info.record, info.parameters, true);
}

/**
 *  Determine if a log level is enabled.
 *
 *  @api private
 *
 *  @param level The log level.
 *  @param source A source log level configured on a stream.
 */
Logger.prototype.enabled = function(level, source) {
  var stream, i;
  if(arguments.length === 1) {
    for(i = 0;i < this.streams.length;i++) {
      stream = this.streams[i];
      if(this.bitwise) {
        if((stream.level&level) === level) {
          return true;
        }
      }else{
        if(level >= stream.level) {
          return true;
        }
      }
    }
  }else{
    if(this.bitwise) {
      return (source&level) === level;
    }else{
      return level >= source;
    }
  }
  return false;
}

/**
 *  Retrieve the string name(s) for a log level.
 *
 *  @param level The log level integer.
 *  @param complex A boolean indicating the level
 *  is a complex bitwise level (combination).
 *
 *  @return A string name for the level or an array
 *  of names if the complex flag is specified, if names
 *  could not be determined for the level the level is returned.
 */
Logger.prototype.names = function(level, complex) {
  var z, names = [], i, value;
  if(!complex) {
    for(z in LEVELS) {
      if(LEVELS[z] === level) return z;
    }
    for(z in BITWISE) {
      if(BITWISE[z] === level) return z;
    }
  }else{
    for(i = 0;i < keys.length;i++) {
      z = keys[i];
      value = BITWISE[z];
      if((level&value) === value) names.push(z);
    }
    return names;
  }
  return level;
}

/**
 *  Create a child of this logger.
 *
 *  @param conf The configuration for the child logger.
 *  @param bitwise A boolean indicating that log levels
 *  should use bitwise operators.
 *
 *  @return A child Logger instance.
 */
Logger.prototype.child = function(conf, bitwise) {
  return new Logger(conf,
    bitwise !== undefined ? bitwise : this.bitwise, this);
}

/**
 *  Get or set the current log level.
 *
 *  @param level A log level to set on all streams.
 *
 *  @return The lowest log level when no arguments are specified.
 */
Logger.prototype.level = function(level) {
  var i, j, stream, min = this._levels.none;
  if(!arguments.length) {
    if(!this.bitwise) {
      for(i = 0;i < this.streams.length;i++) {
        stream = this.streams[i];
        min = Math.min(min, stream.level);
      }
    }else{
      min = Number.MAX_VALUE;
      var keys = Object.keys(BITWISE);
      var none = keys.shift();
      var zero = BITWISE[none], value;
      for(i = 0;i < this.streams.length;i++) {
        stream = this.streams[i];
        if(stream.level === zero) return zero;
        for(j = 0;j < keys.length;j++) {
          value = BITWISE[keys[j]];
          if((stream.level&value) === value) {
            min = Math.min(min, value);
          }
        }
      }
    }
    return min;
  }else{
    if(this.bitwise && typeof(level) !== 'number') {
      throw new Error('Value for bitwise levels must be a number');
    }
    level = this.bitwise ? level : this.resolve(level);
    for(i = 0;i < this.streams.length;i++) {
      stream = this.streams[i];
      stream.level = level;
    }
  }
}

/**
 *  Get or set the current log level for streams.
 *
 *  @param name The stream integer index or name.
 *  @param level The new level for the stream(s).
 */
Logger.prototype.levels = function(name, level) {
  var stream, i, levels;
  if(!arguments.length) {
    levels = [];
    this.streams.forEach(function(stream) {
      levels.push(stream.level);
    })
    return levels;
  }else{
    if(typeof name == 'number') {
      stream = this.streams[name];
    }else{
      for(i = 0;i < this.streams.length;i++) {
        if(this.streams[i].name === name) {
          stream = this.streams[i];
          break;
        }
      }
    }
    if(!stream) throw new Error('No stream found matching \'' + name + '\'');
    if(arguments.length === 1) {
      return stream.level;
    }else{
      stream.level = this.resolve(level);
    }
  }
}

/**
 *  Log a trace message.
 *
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.trace = function() {
  var lvl = this._levels.trace;
  if(!arguments.length) return this.enabled(lvl);
  var args = [].slice.call(arguments, 0);
  args.unshift(lvl);
  return this.log.apply(this, args);
}

/**
 *  Log a debug message.
 *
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.debug = function() {
  var lvl = this._levels.debug;
  if(!arguments.length) return this.enabled(lvl);
  var args = [].slice.call(arguments, 0);
  args.unshift(lvl);
  return this.log.apply(this, args);
}

/**
 *  Log an info message.
 *
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.info = function info() {
  var lvl = this._levels.info;
  if(!arguments.length) return this.enabled(lvl);
  var args = [].slice.call(arguments, 0);
  args.unshift(lvl);
  return this.log.apply(this, args);
}

/**
 *  Log a warn message.
 *
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.warn = function() {
  var lvl = this._levels.warn;
  if(!arguments.length) return this.enabled(lvl);
  var args = [].slice.call(arguments, 0);
  args.unshift(lvl);
  return this.log.apply(this, args);
}

/**
 *  Log an error message.
 *
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.error = function() {
  var lvl = this._levels.error;
  if(!arguments.length) return this.enabled(lvl);
  var args = [].slice.call(arguments, 0);
  args.unshift(lvl);
  return this.log.apply(this, args);
}

/**
 *  Log a fatal message.
 *
 *  @param message The log message.
 *  @param ... The message replacement parameters.
 */
Logger.prototype.fatal = function() {
  var lvl = this._levels.fatal;
  if(!arguments.length) return this.enabled(lvl);
  var args = [].slice.call(arguments, 0);
  args.unshift(lvl);
  return this.log.apply(this, args);
}

var ConsoleStream = require('./lib/console-stream');
var RingBuffer = require('./lib/ring-buffer');
var serializers = require('./lib/serializers');

/**
 *  Create a Logger and set json configuration
 *  to true if it has not been defined.
 *
 *  Defined for bunyan compatibility.
 *
 *  @param conf The logger configuration.
 *  @param bitwise A boolean indicating that log levels
 *  should use bitwise operators.
 */
function createLogger(conf, bitwise) {
  conf = conf || {};
  if(conf.json === undefined) conf.json = true;
  return new Logger(conf, bitwise);
}

/**
 *  Create a logger.
 *
 *  @param conf The logger configuration.
 *  @param bitwise A boolean indicating that log levels
 *  should use bitwise operators.
 */
module.exports = function(conf, bitwise, parent) {
  return new Logger(conf, bitwise, parent);
}

function constants(target) {
  for(z in LEVELS) {
    target[z.toUpperCase()] = LEVELS[z];
  }
  for(z in BITWISE) {
    target['BW_' + z.toUpperCase()] = BITWISE[z];
  }
}

module.exports.levels = LEVELS;
module.exports.bitwise = BITWISE;
module.exports.types = types;
module.exports.keys = keys;
module.exports.serializers = module.exports.stdSerializers = serializers;
module.exports.circular = circular;
module.exports.createLogger = createLogger;
module.exports.Logger = Logger;
module.exports.ConsoleStream = ConsoleStream;
module.exports.RingBuffer = RingBuffer;
constants(module.exports);
module.exports.RAW = RAW;
module.exports.STREAM = STREAM;
module.exports.FILE = FILE;
module.exports.CONSOLE = CONSOLE;
module.exports.LOG_VERSION = major;
