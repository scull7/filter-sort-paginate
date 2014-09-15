var Promise                 = require('bluebird'),
    FSPMongooseQueryList    = require(__dirname + '/query/list'),
    FSPMongooseQueryCount   = require(__dirname + '/query/count')
;

// `FSPMongoose`
// -------------
// @param {http.IncomingMessage} req
// @param {FSPTransport} transport
// @param {function} done
// @return {void}
// @api {public}
function FSPMongoose (req, transport, done) {
    var connection  = req.mongoose,
        listQuery   = FSPMongooseQueryList(connection, transport),
        countQuery  = FSPMongooseQueryCount(connection, transport)
    ;

    Promise.join(listQuery, countQuery).spread(function (list, count) {
        transport.items         = list.rows;
        transport.field_data    = list.fields;
        transport.total         = count;

        return done(null, transport);
    }).catch(done);
}
module.exports  = FSPMongoose;
