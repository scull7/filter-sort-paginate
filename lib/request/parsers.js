var format            = require('util').format,
    FSPFilter         = require(__dirname + '/../filter'),
    FSPSort           = require(__dirname + '/../sort'),
    FSPParameterError = require(__dirname + '/../error').FSPParameterError
;
// `Parsers`
// =========
// A collection of string parsers
// that take in request parameters
// and return object representations.

// `tokenize`
// ----------
// A simple tokenizer function.
// @param {string} string
// @param {string} separator
// @return {Array.<string>}
// @api {private}
function tokenize (string, separator) {
  separator = separator || '|';

  return (string + "").split(separator);
}

// `filterQuery`
// --------------
// Parse the given filter request query parameter string into
// an array of FSPFilter objects.
// @param {string} query
// @param {string} separator
// @return {Array.<FSPFilter>}
// @api {public}
function filterQuery (query, separator) {
  var filters = [];

  tokenize(query, separator).forEach(function (token) {
    var tokens = tokenize(token, ':');

    if(!tokens || tokens.length !== 3) {
      throw new FSPParameterError(
        "filterQuery", "Invalid filter token %s in string %s", token, query
      );
    }

    filters.push( new FSPFilter(tokens[0], tokens[1], tokens[2]) );
  });

  return filters;
}

// `sortString`
// ------------
// Parse the given sort request query parameter string into an
// array of FSPSort objects.
// @param {string} query
// @param {string} separator
// @return {Array.<FSPSort>}
// @api {public}
function sortQuery(query, separator) {
  var columns   = [],
      sorts     = [],
      regex     = /^[+-]?[a-zA-Z]+[a-zA-Z0-9_]+$/
  ;
  tokenize(query, separator).forEach(function (token) {
    if (!regex.test(token)) {
      throw new FSPParameterError(
        "sortQuery", "Invalid sort token: %s, in string %s", token, query
      );
    }
    var column      = token.replace(/\+|-/, ''),
        direction   = token[0] === '-' ? '-' : '+'
    ;
    if (columns.indexOf(column) !== -1) {
      throw new FSPParameterError(
        "sortQuery", "Duplicate sort column: %s, in string: %s", column, query
      );
    }
    columns.push(column);

    sorts.push( new FSPSort(column, direction) );
  });
  
  return sorts;
}

module.exports  = {
  filterQuery: filterQuery,
  sortQuery: sortQuery
};