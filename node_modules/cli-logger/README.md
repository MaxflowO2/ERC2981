# Logger

Logger implementation for command line interfaces.

This module is inspired by and borrows from [bunyan][bunyan] it differs primarily in that it is designed for command line interfaces rather than long running services. For all intents and purposes it is a drop in replacement for [bunyan][bunyan], see [credits](#credits) for more information.

The library is considered feature complete and ready for use, however the major version has not been incremented to `1` to maintain compatibility with [bunyan][bunyan].

## Install

```
npm install cli-logger
```

## Test

```
npm test
```

## Features

* Seamless integration with [ttycolor][ttycolor]
* JSON output compatible with [bunyan][bunyan]
* Bitwise log level support
* 100% code coverage

## Examples

Example programs are in the [bin][bin] directory and there are many usage examples in the [test suite][test suite].

## Usage

Unless [streams](#streams) have been configured all log messages are written to `process.stdout`.

### Normal

Normal mode uses log levels that correspond to the [bunyan][bunyan] log levels and behaviour (log messages are written if they are greater than or equal to the configured log level): 

```javascript
var logger = require('cli-logger');
var conf = {level: log.WARN};
log = logger(conf);
log.warn('mock %s message', 'warn');
// this will not be logged as the log level is warn
log.info('mock %s message', 'info');
```

### Bitwise

Using bitwise log levels allows fine-grained control of how log messages are routed, to enable bitwise mode pass `true` as the second argument when creating the logger:

```javascript
var logger = require('cli-logger');
var conf = {level: log.BW_INFO|log.BW_FATAL};
log = logger(conf, true);
log.info('mock %s message', 'info');
```

If you just want to disable one or two log levels it is more convenient to use the `XOR` operator:

```javascript
var logger = require('cli-logger');
var conf = {level: log.BW_ALL^log.BW_TRACE};
log = logger(conf, true);
log.info('mock %s message', 'info');
```

Note that in normal mode you may use string log levels, such as `'trace'`, but in bitwise mode you may only use integer log levels.

## Messages

Logging messages is consistent with [bunyan][bunyan]:

```javascript
log.info('info message')                        // log a simple message
log.warn('%s message', 'warn')                  // log a message with parameters
log.debug({foo: 'bar'}, '%s message', 'debug')  // add field(s) to the log record
log.error(err)                                  // log an Error instance
log.fatal(err, '%s error', 'fatal')             // log an Error with custom message
```

## Log Levels

The log levels correspond to a method on the logger, the methods and corresponding module constants are shown below:

```javascript
log.trace()          // TRACE: 10 | BW_TRACE: 1
log.debug()          // DEBUG: 20 | BW_DEBUG: 2
log.info()           // INFO: 30  | BW_INFO: 4
log.warn()           // WARN: 40  | BW_WARN: 8
log.error()          // ERROR: 50 | BW_ERROR: 16
log.fatal()          // FATAL: 60 | BW_FATAL: 32
```

In normal mode the additional constant `NONE` (70) may be used to disable logging. In bitwise mode you may also use `BW_NONE` (0) and `BW_ALL` (63), `BW_ALL` is particularly useful for `XOR` operations, see [constants](#constants).

The API for getting and setting log levels is identical to [bunyan][bunyan]:

```javascript
log.info()                    // true if any stream is enabled for the info level
log.level()                   // get a level integer (lowest level of all streams)
log.level(log.INFO)           // sets all streams to the INFO level
log.level('info')             // sets all streams to the INFO level (normal)
log.levels()                  // gets an array of the levels of all streams
log.levels(0)                 // get level of stream at index zero
log.levels('foo')             // get level of the stream named 'foo'
log.levels(0, log.INFO)       // set level of stream at index zero to INFO
log.levels(0, 'info')         // set level of stream at index zero to INFO (normal)
log.levels(0, log.INFO)       // set level of stream at index zero to INFO
log.levels('foo', log.WARN)   // set level of stream named 'foo' to WARN
```

## Configuration

* `console`: A boolean indicating that console methods should be used when writing log records, this enables the [ttycolor][ttycolor] integration, default is `false`, see [console](#console).
* `hostname`: Allows overriding the `hostname` field added to all log records, default is `null` but is automatically set to `os.hostname()` if not specified, see [record](#record).
* `json`: Print log records as newline delimited JSON, default is `false`, see [json](#json).
* `level`: A default log level to use when a stream does not explicitly specify a log level, default is `INFO`, see [level](#level).
* `name`: The name of the logger, default is `basename(process.argv[1])`, see [name](#name).
* `pid`: Allows overriding the `pid` field added to all log records, default is `null` but is automatically set to `process.pid` if not specified, see [record](#record).
* `prefix`: A function used to prepend a prefix to log messages, default is `null`, see [prefix](#prefix).
* `serializers`: Map of log record property names to serialization functions,
  default is `null`, see [serializers](#serializers).
* `src`: A boolean that indicates that file name, line number and function name (when available) should be included in the log record, default is `false`, see [source](#source).
* `stack`: A boolean used in conjunction with `src` to also include an array of the stack trace caller information, default is `false`, see [source](#source).
* `stream`: Shortcut for specifying a stream for single stream loggers, default is `null`, see [streams](#streams).
* `streams`: An array or object that configures the streams that log records are written to, by default if this property is not present a single stream is configured for `process.stdout`, see [streams](#streams).
* `writers`: Map of log level string names to console functions, default is
  `null`. Use this to customize the functions used when `console` is `true`,
  see [writers](#writers).
* `formatter`: A formatter function or string formatter name. Supported names are `pedantic`, `capitalize` and `normalize`. Signature is `function(record, parameters, format)`; `record` is the log record about to be written, `parameters` is the message replacement parameters and `format` is the default formatter function bound to the logger instance. Formatter functions are invoked in the scope of the logger.

If you specify any unknown properties in the configuration then these are considered *persistent fields* and are added to every log record. This is a convenient way to add labels for sub-components to log records.

### Console

Set the `console` configuration property to redirect all log messages via `console` methods, this enables integration with the [ttycolor][ttycolor] module.

The default mapping between log methods and `console` methods is:

```javascript
trace   // => console.log
debug   // => console.log
info    // => console.info
warn    // => console.warn
error   // => console.error
fatal   // => console.error
```

Run the [color][color] example program to see the default output.

### Writers

You may customize the mapping between log methods and `console` methods by either specifying the `writers` configuration property as a `console` function (to set all log methods to the same `console` method):

```javascript
var conf = {console: true, writers: console.error};
```

Or by mapping individual log method names, for example if you would prefer `trace` and `debug` messages to be printed to `stderr`:

```javascript
var conf = {
  console: true,
  writers: {
    trace: console.error,
    debug: console.error
  }
}
```

If required you could define your own function that has the same signature as a `console` method (`function(message, ...)`) to create different output styles using the [ttycolor][ttycolor] module methods.

This configuration option should only be used in conjunction with the `console` option.

### JSON

This module is designed for command line interfaces so JSON output is not enabled by default, you may enable JSON output for all streams by specifying the `json` configuration option or enable for specific streams by specifying the `json` property on a stream.

Alternatively, you can use `createLogger` to set the `json` configuration property if it is not defined:

```javascript
var logger = require('cli-logger');
log = logger.createLogger();
// ...
```

### Level

The `level` configuration option sets the default log level when a level is not specified on a stream, it may also be used in conjunction with `stream` to configure a single stream, see [streams](#streams) for an example.

### Name

All loggers must have a `name` specified, typically this will be the name of the program so it is determined automatically, however you can override with a different `name` if required. Note that when specified this option must be a non-zero length string or an error will be thrown.

### Prefix

Sometimes it may be useful to prefix all log messages, possibly with the program name, log level or date. Specify a function as the `prefix` configuration option to set a prefix for all log messages. The function has the signature:

```javascript
function prefix(record)
```

It should return a string to prepend to all log messages.

The `prefix` function is invoked in the scope of the `Logger` instance so you may access `this.name`, `this.names()` etc. See the [prefix][prefix] example program.

### Source

Set the `src` configuration property when you want information about the file name, line number and function name that invoked a log method, you may also set the `stack` property to include a full stack trace.

***Caution: do not use this in production, retrieving call site information is slow.***

```javascript
var logger = require('cli-logger');
var conf = {src: true, stack: true};
var log = logger(conf);
log.on('write', function(record, stream, msg, parameters) {
  console.log(JSON.stringify(record, undefined, 2));
})
function info() {
  log.info('mock %s message', 'info');
}
info();
```

```json
{
  "time": "2014-02-17T16:28:02.573Z",
  "pid": 2747,
  "hostname": "pearl.local",
  "name": "source",
  "msg": "mock info message",
  "level": 30,
  "src": {
    "file": "/Users/cyberfunk/git/cli/logger/bin/source",
    "line": 16,
    "func": "info",
    "stack": [
      "info (/Users/cyberfunk/git/cli/logger/bin/source:16:7)",
      "Object.<anonymous> (/Users/cyberfunk/git/cli/logger/bin/source:18:1)",
      "Module._compile (module.js:456:26)",
      "Object.Module._extensions..js (module.js:474:10)",
      "Module.load (module.js:356:32)",
      "Function.Module._load (module.js:312:12)",
      "Function.Module.runMain (module.js:497:10)"
    ]
  },
  "v": 0
}
```

See the [source][source] example program.

### Serializers

Serializers behave the same as [bunyan][bunyan] and the same standard serializers are provided via the `serializers` module property (also aliased via `stdSerializers` for [bunyan][bunyan] compatibility).

* `req`: Serialize an HTTP request.
* `res`: Serialize an HTTP response.
* `err`: Serialize an Error instance.

```javascript
var logger = require('cli-logger');
var conf = {serializers: {err: logger.serializers.err}};
var log = logger(conf);
log.on('write', function(record, stream, msg, parameters) {
  console.log(JSON.stringify(record, undefined, 2));
})
log.info({err: new Error('Mock simple error')});
```

```json
{
  "time": "2014-02-17T15:54:52.830Z",
  "err": {
    "message": "Mock simple error",
    "name": "Error",
    "stack": "..."
  },
  "pid": 65543,
  "hostname": "pearl.local",
  "name": "write",
  "msg": "",
  "level": 30,
  "v": 0
}
```

See the [serialize][serialize] example program.

### Streams

The following types of streams are supported:

* `stream`: An existing stream such as `process.stdout`, `process.stderr` or some other writable stream. 
* `file`: Creates a writable stream from a string file system path.
* `raw`: Forces the raw log record to always be passed to the `write()` method of the stream.
* `console`: A stream that writes log messages to a `console` method, streams of this type are passed the raw log record which is decorated with the additional properties `message` (the raw message string) and `parameters` (message replacement parameters).

#### Stream

Configuring output streams is typically done using an array, but as a convenience an object may be specified to configure a single output stream:

```javascript
var logger = require('cli-logger');
var conf = {streams: {stream: process.stderr, level: log.WARN}}
var log = logger(conf);
// ...
```

Or even more succinctly for single stream loggers you can specify `stream` at the configuration level:

```javascript
var logger = require('cli-logger');
var conf = {stream: process.stderr, level: log.FATAL}
var log = logger(conf);
// ...
```

#### File

You may configure a file stream by using the `path` stream property. For example, to log the `INFO` level and above to `stdout` and `ERROR` and above to a file:

```javascript
var logger = require('cli-logger');
var conf = {streams: [
  {
    stream: process.stdout,
    level: log.INFO
  },
  {
    path: 'log/errors.log',
    level: log.ERROR
  }
]};
var log = logger(conf);
// ...
```

When creating file streams the default flags used is `a` you may specify the `flags` property to change this behaviour:

```javascript
var logger = require('cli-logger');
var conf = {streams: [
  {
    path: 'log/errors.log',
    flags: 'ax',
    level: log.ERROR
  }
]};
var log = logger(conf);
// ...
```

The `encoding` and `mode` options supported by `fs.createWriteStream` are also respected if present.

#### Raw

The raw stream type is useful when you want to ensure that the stream implementation is passed the raw log record,  this type is implied when using a [ring buffer](#ring-buffer).

#### Console

Use the `console` stream type when you need access to the raw message and message replacement parameters. This stream type is implied when the `console` configuration property is set, alternatively you can use this to redirect some messages to `console` methods and possibly others to a log file as JSON records, for example:

```javascript
var logger = require('cli-logger');
var conf = {
  streams: [
    {
      stream: new logger.ConsoleStream(),
      level: log.BW_TRACE|log.BW_DEBUG|log.BW_INFO
    },
    {
      path: 'log/json.log',
      json: true,
      level: log.BW_ALL^log.BW_TRACE^log.BW_DEBUG^log.BW_INFO
    }
  ]
}
var log = logger(conf, true);
// print to stdout using `console.info`
log.info('mock %s message', 'info');
// print to log file as a json record
log.warn('mock %s message', 'warn');
```

See the [json][json] example program.

## Child Loggers

The module supports child loggers to label subcomponents of your application and follows the same rules as [bunyan][bunyan]:

* All streams are inherited from the parent logger, you may configure child loggers with additional streams but you cannot remove the streams inherited from the parent.
* The parent's serializers are inherited though may be overriden in the child.
* Changes to the log level of a child logger do not affect the parent log level.

See the [child][child] example program.

## Ring Buffer

The `RingBuffer` implementation does not write records to a stream it gathers them into an array (with a specified limit) and optionally can flush the records to a stream at a later time.

This is useful if you wish to keep track of all (or some) log messages and then write a debug log file when a particular event occurs (such as a fatal error).

See the [ringbuffer][ringbuffer] example program.

## Events

The `Logger` implementation dispatches the following events:

### error

Emitted if there is an error on an underlying stream, it is recommended you listen for this event.

```javascript
function error(err, stream)
```

### log

Emitted when a log record has been written to stream(s), if listeners exist for `write` this event will not fire.

```javascript
function log(record, level, msg, parameters)
```

Note that if a log record is written to multiple streams this event will only be emitted once for the log record.

### write

If a listener exists for this event it is invoked with all the log record information and no data is written by the logger to the underlying stream(s).

```javascript
function write(record, stream, msg, parameters)
```

Note that `record.msg` contains the message with parameters substituted, whilst `msg` and `parameters` are the raw message and replacement parameters should you need them. 

This event will fire once for each stream that is enabled for the log level associated with the record and effectively disables all the default logic for writing log records, if you listen for this event it is your responsibility  to process the log record.

## Constants

The exposed log level constants deserve some attention. The module exposes all normal mode levels as constants, eg `INFO` and prefixes bitwise constants for example, `BW_INFO`. However constants are also exposed on the instance regardless of mode, such that the following is possible:

```javascript
var logger = require('cli-logger');
log = logger();
// set level of all streams to warn
log.level(log.WARN);
// ...
```

The equivalent for bitwise mode is:

```javascript
var logger = require('cli-logger');
log = logger(null, true);
// set level of all streams to warn
log.level(log.WARN);
// ...
```

Note that no prefix is necessary when accessing constants on the instance.

The rule of thumb is that if you are setting log levels in the configuration then use the prefixed constants for bitwise mode. If you are setting log levels after instantiation then you can use the constants exposed by the `Logger` instance without a prefix regardless of mode.

## Record

Log record fields are consistent with [bunyan][bunyan], a log record in normal mode may look like:

```json
{
  "time": "2014-02-18T06:42:41.868Z",
  "pid": 31641,
  "hostname": "pearl.local",
  "name": "record",
  "msg": "mock info message",
  "level": 30,
  "v": 0
}
```

See the [record][record] example program.

### Fields

* `v`: Required integer, cannot be overriden. Module major version extracted from `package.json`.
* `level`: Required integer, cannot be overriden. Determined automatically by the log method.
* `name`: Required string, cannot be overriden. Provided at creation or `basename(process.argv[1])`.
* `hostname`: Required string, provided at creation or `os.hostname()`.
* `pid`: Required integer, provided at creation or `process.pid`.
* `time`: Required string, can be overriden. Default is `new Date().toISOString()`.
* `msg`: Required string. Must be supplied when calling a log method.
* `src`: Optional object, contains log caller information. Automatically added if the `src` configuration property has been set.

You may add your own fields to log records by specifying an object as the first argument to a log method, see [messages](#messages). 

## API

### Module

#### logger([conf], [bitwise])

Create a `Logger` instance.

* `conf`: A configuration for the logger.
* `bitwise`: A boolean indicating the logger uses bitwise log levels.

```javascript
var logger = require('cli-logger');
var log = logger();
```

#### createLogger([conf], [bitwise])

Create a `Logger` instance and enable JSON log records for all streams.

* `conf`: A configuration for the logger.
* `bitwise`: A boolean indicating the logger uses bitwise log levels.

```javascript
var logger = require('cli-logger');
var log = logger.createLogger();
```

#### bitwise

Map of all bitwise mode constants.

#### circular

Reference to the function used to safely `stringify` objects that may contain circular references.

#### ConsoleStream

Reference to the `ConsoleStream` class.

#### keys

Array of log method names.

#### levels

Map of all normal mode constants.

#### Logger

Reference to the `Logger` class.

#### RingBuffer

Reference to the `RingBuffer` class.

#### serializers

Map of standard serializer functions, aliased via `stdSerializers`, see [serializers](#serializers).

#### types

Array of supported stream types.

#### Constants (miscellaneous)

* `CONSOLE`: String representing the console stream type.
* `FILE`: String representing the file stream type.
* `LOG_VERSION`: Integer indicating the module major version.
* `RAW`: String representing the raw stream type.
* `STREAM`: String representing the stream type.

#### Constants (normal)

* `TRACE`: Integer representing the trace log level.
* `DEBUG`: Integer representing the debug log level.
* `INFO`: Integer representing the info log level.
* `WARN`: Integer representing the warn log level.
* `ERROR`: Integer representing the error log level.
* `FATAL`: Integer representing the fatal log level.
* `NONE`: Integer representing the none log level.

#### Constants (bitwise)

* `BW_NONE`: Integer representing the none log level.
* `BW_TRACE`: Integer representing the trace log level.
* `BW_DEBUG`: Integer representing the debug log level.
* `BW_INFO`: Integer representing the info log level.
* `BW_WARN`: Integer representing the warn log level.
* `BW_ERROR`: Integer representing the error log level.
* `BW_FATAL`: Integer representing the fatal log level.
* `BW_ALL`: Integer representing the all log level.

### ConsoleStream

Class used to redirect log records to `console` methods.

#### ConsoleStream([options])

Create a `ConsoleStream` instance.

* `options`: Options for the console stream.

The `options` may contain a `writers` property to map log level string names to `console` functions, see [writers](#writers).

### Logger

Class representing the logger implementation.

#### Logger([conf], [bitwise])

Create a `Logger` instance.

* `conf`: A configuration for the logger.
* `bitwise`: A boolean indicating the logger uses bitwise log levels.

#### child([conf], [bitwise])

Creates a child `Logger` instance, see [child loggers](#child-loggers).

* `conf`: A configuration for the child logger.
* `bitwise`: A boolean indicating the child logger uses bitwise log levels.

#### conf

Map of the logger configuration.

#### debug([object], message, ...)

Log a debug message.

* `object`: An object or `Error` instance.
* `message`: The log message.
* `...`: Message replacement parameters.

Returns a boolean indicating whether the log record was written to a stream.

When invoked with zero arguments this method returns a boolean indicating if the `debug` level is enabled for any stream.

#### error([object], message, ...)

Log an error message.

* `object`: An object or `Error` instance.
* `message`: The log message.
* `...`: Message replacement parameters.

Returns a boolean indicating whether the log record was written to a stream.

When invoked with zero arguments this method returns a boolean indicating if the `error` level is enabled for any stream.

#### fatal([object], message, ...)

Log a fatal error message.

* `object`: An object or `Error` instance.
* `message`: The log message.
* `...`: Message replacement parameters.

Returns a boolean indicating whether the log record was written to a stream.

When invoked with zero arguments this method returns a boolean indicating if the `fatal` level is enabled for any stream.

#### info([object], message, ...)

Log an info message.

Returns a boolean indicating whether the log record was written to a stream.

When invoked with zero arguments this method returns a boolean indicating if the `info` level is enabled for any stream.

#### level([level])

Get or set the log level for all streams, see [log levels](#log-levels).

* `level`: Integer level to set on all streams.

Returns the lowest level of all streams when invoked with no arguments.

#### levels([name], [level])

Get or set the log level for individual streams, see [log levels](#log-levels).

* `name`: The name of the stream or a valid index into the streams array.
* `level`: Integer level to set on a stream.

Returns an array of the levels of all streams when invoked with no arguments.

#### name

The string name of the logger.

#### names(level, [complex])

Retrieve the string name of a level from a log level integer.

* `level`: The log level integer.
* `complex`: A boolean indicating that complex bitwise log levels should be resolved to an array of names.

Returns the string log level, or if `complex` is specified an array of log level names.

If `level` could not be resolved to a string name (unknown level) it is returned.

#### trace([object], message, ...)

Log a trace message.

* `object`: An object or `Error` instance.
* `message`: The log message.
* `...`: Message replacement parameters.

Returns a boolean indicating whether the log record was written to a stream.

When invoked with zero arguments this method returns a boolean indicating if the `trace` level is enabled for any stream.

#### warn([object], message, ...)

Log a warn message.

* `object`: An object or `Error` instance.
* `message`: The log message.
* `...`: Message replacement parameters.

Returns a boolean indicating whether the log record was written to a stream.

When invoked with zero arguments this method returns a boolean indicating if the `warn` level is enabled for any stream.

### RingBuffer

Class used to buffer log records in an array.

#### RingBuffer([options])

Create a `RingBuffer` instance.

* `options`: Options for the ring buffer.

The `options` may contain a `limit` integer which determines the maximum number of records to buffer and a `json` boolean which indicates that the log records should be written as JSON when they are flushed.

#### flush(stream, [options])

Flush buffered log records to a stream, the buffered log records are cleared as they are written to the stream.

* `stream`: A string file system path or an existing writable stream.
* `options`: Options passed to `fs.createWriteStream` when `stream` is a string.

When `stream` is a string the created writable stream is destroyed once all records have been written, otherwise if a writable stream is passed you should destroy the stream when necessary.

If `stream` is a string and no `options` are passed the `w` mode is used with `utf8` encoding.

Returns the writable stream.

## Credits

This module is inspired by [bunyan][bunyan], by far the best logging library for [node][node]. Thanks to [trentm][trentm] for the elegant library.

The following functions have been borrowed more or less verbatim from [bunyan][bunyan]:

* `circular` (`safeCycles`)
* `getCallerInfo` (`getCaller3Info`)
* `getFullErrorStack`
* `serializers` (`stdSerializers`)

### Caveats

Bugs notwithstanding, the following list of caveats apply:

* `dtrace`: This library has no `dtrace` support as it is far less likely to be required for command line interfaces. Furthermore, we have had intermittent compile errors while building `dtrace` on Linux which at times has broken automated deployment.
* `rotating-file`: The rotating file stream type has not been implemented as it is more applicable to long running services, if it is ever implemented it will be based on file size as opposed to daily rotation.

This library does not provide a command line tool to inspect JSON log records as it is designed to be compatible with `bunyan(1)` which you can use to view and query JSON logs.

## License

Everything is [MIT](http://en.wikipedia.org/wiki/MIT_License). Read the [license](/LICENSE) if you feel inclined.

[ttycolor]: https://github.com/freeformsystems/ttycolor
[bunyan]: https://github.com/trentm/node-bunyan
[node]: http://nodejs.org/
[trentm]: https://github.com/trentm

[bin]: https://github.com/freeformsystems/cli-logger/tree/master/bin
[test suite]: https://github.com/freeformsystems/cli-logger/tree/master/test/unit

[child]: https://github.com/freeformsystems/cli-logger/tree/master/bin/child
[color]: https://github.com/freeformsystems/cli-logger/tree/master/bin/color
[json]: https://github.com/freeformsystems/cli-logger/tree/master/bin/json
[prefix]: https://github.com/freeformsystems/cli-logger/tree/master/bin/prefix
[record]: https://github.com/freeformsystems/cli-logger/tree/master/bin/record
[ringbuffer]: https://github.com/freeformsystems/cli-logger/tree/master/bin/ringbuffer
[serialize]: https://github.com/freeformsystems/cli-logger/tree/master/bin/serialize
[source]: https://github.com/freeformsystems/cli-logger/tree/master/bin/source
