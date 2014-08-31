var FSPField  = require(__dirname + '/lib/field')
;
// `FSPFactory`
// ------------
// This function initializes the filter-sort-paginate
// module.
// @param {string} table
// @param {Array.<FSPField>} fields
// @param {Object} options
// @return {FSPMiddleware}
function FSPFactory(repository, fields, options) {
  this.repository   = repository;
  this.fields       = FSPField.getManyFromArray(fields);

  return FSPMiddleware.bind(this);
};

function FSPMiddleware(req, res, next) {

}

module.exports  = FSPFactory;