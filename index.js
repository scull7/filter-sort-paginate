var FSPField          = require(__dirname + '/lib/field'),
    FSPRequest        = require(__dirname + '/lib/request'),
    FSPTransport      = require(__dirname + '/lib/transport'),
    FSPParameterError = require(__dirname + '/lib/error').FSPParameterError,
    drivers           = {
      'mysql': require(__dirname + '/lib/driver/mysql/')
    }
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

  if (typeof fields !== 'undefined') {
    this.fields       = FSPField.getManyFromArray(fields);
  }

  options           = options || {};
  options.driver    = options.driver || 'mysql';

  if(!drivers.hasOwnProperty(options.driver)) {
    throw new FSPParameterError(
        "FSPFactory", "Invalid Driver Specified: %s", options.driver
    );
  }
  this.driver       = drivers[options.driver];

  return FSPMiddleware.bind(this);
};

function FSPMiddleware(req, res, next) {
  var transport     = new FSPTransport(this.repository);
  transport.fields  = this.fields;

  transport         = FSPRequest(req, transport);

  this.driver(req, transport, function (err, response) {
    if (err) return next(err);

    return res.json(response);
  });
}

function use(driver) {
  if(!driver.name) {
    throw new FSPParameterError("FSP::use", "You must specify a driver name");
  }
  drivers[driver.name]  = driver;
}
FSPFactory.use  = use;

module.exports  = FSPFactory;