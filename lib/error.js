var format  = require('util').format;

function FSPError (method, template) {
  var args      = Array.prototype.slice.call(arguments, 1)
  ;
  this.message  = method + ': ' + format.apply(null, args);
}
FSPError.prototype              = Object.create(Error.prototype);
FSPError.prototype.name         = 'FSPError';
FSPError.prototype.constructor  = FSPError;

function FSPParameterError() {
  FSPError.apply(this, arguments);
}
FSPParameterError.prototype               = Object.create(FSPError.prototype);
FSPParameterError.prototype.name          = 'FSPParameterError';
FSPParameterError.prototype.constructor   = FSPParameterError;

module.exports  = {
  'FSPError': FSPError,
  'FSPParameterError': FSPParameterError
};