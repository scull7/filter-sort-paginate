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