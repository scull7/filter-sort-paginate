var Promise             = require('bluebird'),
    FSPMySQLQueryList   = require(__dirname + '/query/list'),
    FSPMySQLQueryCount  = require(__dirname + '/query/count')
;
// `FSPMySQL`
// ----------
// This is an FSP driver for MySQL.
// @param {http.IncomingMessage} req
// @param {FSPTransport} transport
// @param {function} done
// @return {void}
// @api {public}
function FSPMySQL (req, transport, done) {
  var connection  = req.mysql,
      listQuery   = FSPMySQLQueryList(connection, transport),
      countQuery  = FSPMySQLQueryCount(connection, transport)
  ;
  Promise.join(listQuery, countQuery).spread(function (list, count) {
    transport.items       = list.rows;
    transport.field_data  = list.fields;
    transport.total       = count;

    return done(null, transport);
  }).catch(done);
}

module.exports = FSPMySQL;