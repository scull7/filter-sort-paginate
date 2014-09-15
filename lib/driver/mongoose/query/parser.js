// `parseFilter`
// -------------
// Take the given query object
// and filter object and return a
// query condition.
// @param {mongoose.Query} query
// @param {FSPFilter} filter
// @return {mongoose.Query}
// @api {public}
function parseFilter (query, filter) {
    var value       = filter.value,
        method      = filter.action
    ;
    switch (filter.action) {
        case "is":       
            method  = "equals";
            break;

        case "like":
            method  = "where";
            value   = new RegExp(value);
            break;

        case "starts":
            method  = "where";
            value   = new RegExp('^'+value);
            break;

        case "ends":
            method  = "where";
            value   = new RegExp(value + '$');
            break;
    }
    if (method === "where") {
        return query.where(filter.column, value);
    }
    return query.where(filter.column)[method](value);
}

module.exports  = {
    'filter': parseFilter
};
