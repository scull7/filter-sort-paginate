var Promise                 = require('bluebird'),
    FSPMySQLQueryTranslator = require(__dirname + '/translator')
;

function FSPMySQLQueryCount (connection, transport) {
  var sql         = "",
      translator  = new FSPMySQLQueryTranslator(connection);
  ;

  sql += "SELECT COUNT(*) AS `count`";
  sql += translator.from(transport.repository);
  sql += translator.filters(transport.filters);

  return new Promise(function (resolve) {
    connection.query(sql, function (err, rows) {
      if (err) {
        throw err;
      }
      return resolve( rows[0].count );
    });
  });
}

module.exports  = FSPMySQLQueryCount;