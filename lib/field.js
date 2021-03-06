var isArray           = require('util').isArray,
    isColumnName      = require(__dirname + '/validators').isColumnName,
    FSPParameterError = require(__dirname + '/error').FSPParameterError
;
// `FSPField`
// ==========
// This is an object that represents a
// query field.
// @param {string} name
// @param {string} alias
// @constructor
function FSPField(name, alias) {
  if (!isColumnName(name)) {
    throw new FSPParameterError('FSPField', "Invalid field name: %s", name);
  }

  this.name   = name;
  this.alias  = alias || null;
};

// `getManyFromArray`
// ------------------
// Get an array of FSPField objects from the
// given array.
//
FSPField.getManyFromArray = function getManyFromArray (fields) {
  if (!isArray(fields)) {
    throw new FSPParameterError(
        'FSPField::getManyFromArray', "Invalid fields parameter: %j", fields
    );
  }
  var fsp_fields  = [];
  fields.forEach(function (field_data) {
    if(typeof field_data === 'string') {
      fsp_fields.push( new FSPField(field_data) )

    } else if( {}.toString.apply(field_data) === '[object Object]' ) {
      fsp_fields.push( new FSPField(field_data.name, field_data.alias) );
    } else {
      throw new FSPParameterError(
          "FSPField::getManyFromArray", "Invalid field specified: %j", field_data
      );
    }
  });
  return fsp_fields;
};

module.exports = FSPField;