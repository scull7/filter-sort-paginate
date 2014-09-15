var Promise             = require('bluebird'),
    FSPMongooseParser   = require(__dirname + '/parser')
;
function FSPMongooseQueryCount (mongoose, transport) {
    var query   = mongoose.model(transport.repository).find();

    transport.filters.forEach(function (filter) {
        query   = FSPMongooseParser.filter(query, filter);
    });

    return new Promise( function (resolve, reject) {
        query.count(function (err, count) {
            if (err) {
                return reject(err);
            }
            return resolve(count);
        });
    });
}

module.exports  = FSPMongooseQueryCount;
