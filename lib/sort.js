var validators        = require(__dirname + '/validators'),
    FSPParameterError = require(__dirname + '/error').FSPParameterError
;
// `FSPSort`
// ---------
// An object that represents a sort query parameter.
// @param {string} column
// @param {string} direction
// @constructor
function FSPSort (column, direction) {
  if (!validators.isColumnName(column)) {
    throw new FSPParameterError("FSPSort", "Invalid column name: %s", column);
  }
  if (typeof direction !== 'undefined' && !validators.isSortDirection(direction)) {
    throw new FSPParameterError("FSPSort", "Invalid direction: %s", direction);
  }
  this.column     = column;

  if (direction === 'DESC' || direction === '-') {
    this.direction  = '-';
  } else {
    this.direction  = '+';
  }
}
module.exports = FSPSort;