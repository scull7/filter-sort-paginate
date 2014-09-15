var Promise             = require('bluebird'),
    FSPMongooseParser   = require(__dirname + '/parser')
;

function FSPMongooseQueryList (mongoose, transport) {
    var query   = mongoose.model(transport.repository).find();

    transport.filters.forEach(function (filter) {
        query   = FSPMongooseParser.filter(query, filter);
    });

    transport.sorts.forEach(function (sort) {
        query.sort( sort.direction + sort.column );
    });

    query.limit(transport.limit);
    query.skip( (transport.page - 1) * transport.limit );

    return new Promise( function (resolve, reject) {
        query.exec(function (err, list) {
            if (err) {
                return reject(err);
            }
            return resolve({ rows: list });
        });
    });
}

module.exports  = FSPMongooseQueryList;
