var FSPFilter = require(__dirname + '/filter')
// `Validators`
// ============
// A collection of validation functions.

// `isColumnName`
// --------------
// Is the given string a valid column name?
// @param {string} name
// @return {bool}
// @api {public}
exports.isColumnName = function isColumnName(name) {
  var regex   = /^[a-zA-Z]+[a-zA-Z0-9_]*$/;
  return regex.test(name);
};

// `isSortDirection`
// -----------------
// Is the given string a valid sort direction?
// @param {string} direction
// @return {bool}
// @api {public}
exports.isSortDirection = function isSortDirection(direction) {
  var valid   = ['ASC', '+', 'DESC', '-'],
      index   = valid.indexOf(direction)
  ;
  return index !== -1 ? true : false;
};

// `isFilterAction`
// ----------------
// Is the given filter action a valid action?
// @param {string} action
// @return {bool}
// @api {public}
exports.isFilterAction  = function isFilterAction(action) {
  var index = FSPFilter.actions.indexOf(action);
  return index !== -1 ? true : false;
};