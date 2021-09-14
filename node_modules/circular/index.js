/**
 *  Check circular references.
 *
 *  @param ref A function that returns an alternative reference.
 *  @param methods A boolean that indicates functions should be
 *  coerced to strings.
 */
function circular(ref, methods) {
  ref = ref || '[Circular]';
  var seen = [];
  return function (key, val) {
    if(typeof val === 'function' && methods) {
      val = val.toString();
    }
    if(!val || typeof (val) !== 'object') {
      return val;
    }
    if(~seen.indexOf(val)) {
      if(typeof ref === 'function') return ref(val);
      return ref;
    }
    seen.push(val);
    return val;
  };
}

function stringify(obj, indent, ref, methods) {
  return JSON.stringify(obj, circular(ref, methods), indent);
}

module.exports = circular;
module.exports.stringify = stringify;
