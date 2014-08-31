
function FSPMySQL (connection, transport, done) {
  var listQuery   = FSPMySQLQueryList(connection, transport),
      countQuery  = FSPMySQLQueryCount(connection, transport)
  ;
  Promise.join(listQuery, countQuery).spread(function (list, count) {
    transport.items       = list[0];
    transport.field_data  = list[1];
    transport.total       = count;

    return done(null, data);
  }).catch(done);
}

module.exports = FSPMySQL;