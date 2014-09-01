[![Build Status](https://travis-ci.org/scull7/filter-sort-paginate.svg?branch=master)](https://travis-ci.org/scull7/filter-sort-paginate)
[![Coverage Status](https://img.shields.io/coveralls/scull7/filter-sort-paginate.svg)](https://coveralls.io/r/scull7/filter-sort-paginate)
[![Code Climate](https://codeclimate.com/github/scull7/filter-sort-paginate/badges/gpa.svg)](https://codeclimate.com/github/scull7/filter-sort-paginate)

filter-sort-paginate
====================

This is a simple filter sort paginate module designed to work 
with expressJS like frameworks.

usage
-----

```javascript

var fsp     = require('filter-sort-paginate'),
    express = require('express'),
    mysql   = require('mysql'),
    app     = express()
;

app.use(function (req, res, next) {
  req.mysql = ... //get mysql connection
});

app.get('/', fsp('table_name'))

```

The response will be an object that has the following structure:

```javascript
{
  items: [ { name: 'value' }, ... ],
  total: 10, // total number of items produced by the query.
  field_data: [ { /* column data from mysql */ ... ],
  repository: 'table_name', // name of the current table.
  fields: [ /* any currently specified fields */ ],
  sorts: [ /* any currently specified sort fields */ ],
  filters: [ /* any currently specified filters */ ],
  limit: 100, // 100 is the default limit
  page: 1, // page is one based
}
```

Given the following request URL

`/?filter=test:is:something|this:gt:that&sort=+test|-that&page=2&limit=25`

With the following set up.

```javascript
  app.get('/', fsp('table_name', [ 'test', { column: 'this', alias: 'me' }, 'that' ]));
```

The following response will be generated

```javascript
{
  items: [ { test: 'something', this: 'then', that: 'this' }, ... ],
  total: 10, // total number of items produced by the query.
  field_data: [ { /* column data from mysql */ ...} ],
  repository: 'table_name', // name of the current table.
  fields: [
    { column: 'test', alias: null },
    { column: 'this', alias: 'me' },
    { column: 'that', alias: null }
  ],
  sorts: [
    { column: 'test', direction: '+' },
    { column: 'that', direction: '-' }
  ],
  filters: [
    { column: 'test', action: 'is', value: 'something' },
    { column: 'this', action: 'gt', value: 'that' }
  ],
  limit: 25, // 100 is the default limit
  page: 2, // page is one based
}
```

To Do
-----

* Fix exceptions in MySQL driver not being caught.
* Add concept of defaults to the options array.  
  These will be default filters, sorts, etc...
