var isArray           = require('util').isArray,
    FSPFilter         = require(__dirname + '/../../../filter'),
    FSPSort           = require(__dirname + '/../../../sort'),
    FSPValidators     = require(__dirname + '/../../../validators'),
    FSPParameterError = require(__dirname + '/../../../error').FSPParameterError,
    FSPMySQLQueryTemplates  = require(__dirname + '/templates')
;
// `FSPMySQLQueryTranslator`
// =========================
// An object that knows how to translate
// FSPQuery objects into SQL.
// @param {mysql.Client} connection
// @constructor
function FSPMySQLQueryTranslator (connection) {
  this.mysql    = connection;
  this.escape   = connection.escape.bind(connection);
  this.escapeId = connection.escapeId.bind(connection);
}
FSPMySQLQueryTranslator.prototype = {
  // `render`
  // --------
  // Given a template string and Key/Value object
  // Replace all ":key" tags in the template with the
  // corresponding value.
  // @param {string} template
  // @param {Object.<string,string>} values
  // @api {public}
  render: function (template, values) {
    var rendered  = template;

    Object.keys(values).forEach(function (key) {
      var regex = new RegExp(':'+key, 'g');
      rendered  = rendered.replace(regex, values[key]);
    });
    return rendered;
  },
  // `fields`
  // --------
  // Translate the given array of FSPFields
  // into a SQL select statement.
  // @param {Array.<FSPField>} fields
  // @return {string}
  // @api {public}
  fields: function (fields) {
    if(
        ( typeof fields === 'string' && fields.toLowerCase() === 'all' ) ||
        fields === '*' ||
        ( isArray(fields) && fields.length < 1 )
    ) {
      return "SELECT *";

    } else if (!isArray(fields)) {
      throw new FSPParameterError(
        "FSPMySQLTranslator::fields()", "fields parameter is not valid: %j", fields
      );
    }
    var field_array = [],
        escapeId    = this.escapeId
    ;
    fields.forEach(function (field) {
      var sanitized = "";

      if(!field.alias) {
        sanitized = escapeId(field.name);
      } else {
        sanitized = escapeId(field.name) + ' AS ' + escapeId(field.alias);
      }
      field_array.push(sanitized);
    });

    return "SELECT " + field_array.join(', ')
  },
  // `from`
  // ------
  // Translate a given table name to a SQL FROM clause
  // @param {string} table
  // @return {string}
  // @api {public}
  from: function (table) {
    if(typeof table !== 'string' || !FSPValidators.isColumnName(table)) {
      throw new FSPParameterError(
          "FSPMySQLTranslator::from()", "table parameter is not valid: %j", table
      );
    }
    var values  = {
      table: this.escapeId(table)
    };
    return this.render(" FROM :table", values);
  },
  // `filters`
  // ---------
  // Translate the given array of FSPFilters
  // into a SQL WHERE Clause
  // @param {Array.<FSPFilter>} filters
  // @return {string}
  // @api {public}
  filters: function (filters) {
    if(!isArray(filters)) {
      throw new FSPParameterError(
        "FSPMySQLTranslator::filters()", "filters parameter is not valid: %j", filters
      );
    }
    var sql       = "",
        render    = this.render,
        escape    = this.escape,
        escapeId  = this.escapeId,
        templates = FSPMySQLQueryTemplates.actions
    ;

    filters.forEach(function (filter) {
      if (! (filter instanceof FSPFilter) ) {
        throw new FSPParameterError(
          "FSPMySQLTranslator::filters()", "filter is not valid: %j", filter
        )
      }
      var sanitized = {
        column: escapeId(filter.column)
      };

      if(isArray(filter.value)) {
        sanitized.value = [];

        filter.value.forEach(function (value) {
          sanitized.value.push( escape(value) );
        });
      } else {
        sanitized.value = escape(filter.value);
      }

      if(sql === "") {
        sql += " WHERE "
      } else {
        sql += " AND "
      }
      sql += render(templates[filter.action], sanitized);
    });
    return sql;
  },
  // `sorts`
  // -------
  // Translate the given array of FSPSort
  // objects into a SQL ORDER BY clause.
  // @param {Array.<FSPSort>} sorts
  // @return {string}
  // @api {public}
  sorts: function (sorts) {
    if(!isArray(sorts)) {
      throw new FSPParameterError(
          "FSPMySQLTranslator::sorts()", "sorts parameter is not valid: %j", sorts
      );
    }
    var sql         = "",
        escapeId    = this.escapeId,
        sort_array  = []
    ;

    sorts.forEach(function (sort) {
      if(! (sort instanceof FSPSort)) {
        throw new FSPParameterError(
            "FSPMySQLTranslator::sorts()", "sort is not valid: %j", sort
        )
      }
      var column    = escapeId(sort.column),
          direction = 'ASC'
      ;
      if(sort.direction.toUpperCase() === 'DESC' || sort.direction === '-') {
        direction   = 'DESC';
      }
      sort_array.push( column + ' ' + direction)
    });

    if (sort_array.length > 0) {
      sql = " ORDER BY " + sort_array.join(', ');
    }

    return sql;
  },
  // `page`
  // ------
  // Return a LIMIT query to set the result set
  // to the given page of results when returning
  // the given row_count
  // @param {number} page - one (1) based page number.
  // @param {number} row_count
  // @api {public}
  page: function (page, row_count) {
    if(parseInt(page, 10) !== page) {
      throw new FSPParameterError(
        "FSPMySQLTranslator::page()", "page parameter is not valid: %j", page
      );
    }
    if(parseInt(row_count, 10) !== row_count) {
      throw new FSPParameterError(
        "FSPMySQLTranslator::page()", "row_count parameter is not valid: %j", row_count
      );
    }
    if (page < 1) {
      throw new FSPParameterError(
        "FSPMySQLTranslator::page()", "page parameter must be greater than one (1): %j", page
      );
    }
    var values  = {
      offset: (page - 1) * row_count,
      row_count: row_count
    };

    return this.render(" LIMIT :row_count OFFSET :offset", values);
  }
};

module.exports  = FSPMySQLQueryTranslator;
