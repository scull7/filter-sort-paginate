var Promise                 = require('bluebird'),
    FSPMySQLQueryTranslator = require(__dirname + '/translator')
;

function FSPMySQLQueryList (connection, transport) {
  var sql         = "",
      translator  = new FSPMySQLQueryTranslator(connection);
  ;
  sql += translator.fields(transport.fields);
  sql += translator.from(transport.repository);
  sql += translator.filters(transport.filters);
  sql += translator.sorts(transport.sorts);
  sql += translator.page(transport.page, transport.limit);

  return new Promise(function (resolve) {
    connection.query(sql, function (err, rows, fields) {
      if (err) {
        throw err;
      }
      return resolve({ rows: rows, fields: fields });
    });
  });
}

module.exports  = FSPMySQLQueryList;