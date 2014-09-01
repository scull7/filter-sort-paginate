var Promise             = require('bluebird'),
    FSPMySQLQueryList   = require(__dirname + '/query/list'),
    FSPMySQLQueryCount  = require(__dirname + '/query/count')
;
function FSPMySQL (connection, transport, done) {
  var listQuery   = FSPMySQLQueryList(connection, transport),
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