var validators        = require(__dirname + '/validators'),
    FSPParameterError = require(__dirname + '/error').FSPParameterError
;
// `FSPFilter`
// -----------
// An object that represents a filter query parameter
// @param {string} column
// @param {string} action
// @param {string|Array.<string>} value
function FSPFilter (column, action, value) {
  if(!validators.isColumnName(column)) {
    throw new FSPParameterError('FSPFilter', 'Invalid Column: %s', column);
  }
  if(!validators.isFilterAction(action)) {
    throw new FSPParameterError('FSPFilter', 'Invalid Action: %s', action);
  }
  if(typeof value === 'undefined') {
    throw new FSPParameterError('FSPFilter', 'Value is required');
  }
  this.column = column;
  this.action = action;
  this.value  = value;
}
FSPFilter.actions = [
    "equals",
    "is",
    "lt",
    "lte",
    "gt",
    "gte",
    "like",
    "starts",
    "ends",
    "in"
];
module.exports  = FSPFilter;