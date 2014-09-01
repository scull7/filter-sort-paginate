var parsers       = require(__dirname + '/request/parsers')
;
// `FSPRequest`
// ------------
// This is a function that takes in an http.IncomingMessage object
// and returns the FSPTransport object.
// @param {http.IncomingMessage} req
// @param {FSPTransport}
// @return {FSPTransport}
// @api {public}
module.exports = function (req, transport) {
  var filters, sorts,
      page  = 1,
      limit = 100;

  if(typeof req.query !== 'object' || !req.query) return transport;

  if(req.query.filter) {
    filters = parsers.filterQuery(req.query.filter);
    transport.filters = filters;
  }

  if(req.query.sort) {
    sorts   = parsers.sortQuery(req.query.sort);
    transport.sorts   = sorts;
  }

  if(req.query.page) {
    page = parseInt(req.query.page, 10);
  }
  transport.page  = page;

  if(req.query.limit) {
    limit = parseInt(req.query.limit, 10);
  }
  transport.limit = limit;

  return transport;
}
