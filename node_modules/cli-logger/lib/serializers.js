var serializers = {};

/**
 *  Serialize an HTTP request.
 *
 *  @param request The HTTP request.
 *
 *  @return A serialized object.
 */
serializers.req = function req(request) {
  if(!request || !request.connection) return request;
  return {
    method: request.method,
    url: request.url,
    headers: request.headers,
    remoteAddress: request.connection.remoteAddress,
    remotePort: request.connection.remotePort
  }
}

/**
 *  Serialize an HTTP response.
 *
 *  @param request The HTTP response.
 *
 *  @return A serialized object.
 */
serializers.res = function res(response) {
  if(!response || !response.statusCode) return response;
  return {
    statusCode: response.statusCode,
    header: response._header
  }
}

/**
 *  Serialize an Error instance.
 *
 *  @param error The Error instance.
 *
 *  @return A serialized object.
 */
serializers.err = function err(error) {
  if(!error || !error.stack) return error;
  return {
    message: error.message,
    name: error.name,
    stack: getFullErrorStack(error),
    code: error.code,
    signal: error.signal
  }
}

/**
 *  Dumps long stack traces for exceptions having a cause() method.
 *
 *  @param ex The exception.
 *
 *  @return A string representation of the error stack.
 */
function getFullErrorStack(ex) {
  var ret = ex.stack;
  if(ex.cause && typeof(ex.cause) === 'function') {
    var cex = ex.cause();
    if(cex) {
      ret += '\nCaused by: ' + getFullErrorStack(cex);
    }
  }
  return ret;
}

module.exports = serializers;
