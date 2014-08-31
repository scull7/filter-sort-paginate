mysql               = require 'mysql'
FSPField            = requireTarget '/lib/field'
FSPFilter           = requireTarget '/lib/filter'
FSPParser           = requireTarget '/lib/request/parsers'
FSPTransport        = requireTarget '/lib/transport'
FSPMySQLQueryList   = requireTarget '/lib/driver/mysql/query/list'

describe 'FSPMySQLQueryList', ->
  query           = FSPMySQLQueryList
  transport       = null
  mockConnection  = null

  beforeEach ->
    mockConnection  =
      escape: mysql.escape.bind(mysql)
      escapeId: mysql.escapeId.bind(mysql)

    transport       = new FSPTransport('test')

  it 'should be a function with an arity of 2', ->
    FSPMySQLQueryList.should.be.a 'function'
    FSPMySQLQueryList.length.should.equal 2

  it 'should bubble up an error if it receives one', (done) ->
    mockConnection.query  = (sql, cb) ->
      cb "bad juju"

    spy = sinon.spy()

    query(mockConnection, transport).then(spy).catch( (err) ->
      err.should.equal "bad juju"
      spy.called.should.be.false
      done()
    )

  it 'should perform a select * query properly', (done) ->
    mockConnection.query = (sql, cb) ->
      sql.should.equal "SELECT * FROM `test` LIMIT 100 OFFSET 0"
      cb null, [ { test: 'something' }], [{ name: 'test' }]

    transport.fields = "ALL"

    query(mockConnection, transport).then (results) ->
      results.rows[0].test.should.eql 'something'
      results.fields[0].name.should.eql 'test'
      done()

  it 'should perform a select with fields query properly', (done) ->
    mockConnection.query  = (sql, cb) ->
      expected  = "SELECT `no_alias`, `alias` AS `test` " +
                  "FROM `test` " +
                  "LIMIT 100 OFFSET 0"
      sql.should.equal expected
      cb null, [ { test: 'something' }], [{ name: 'test' }]

    transport.fields = [
      new FSPField 'no_alias'
      new FSPField 'alias', 'test'
    ]

    query(mockConnection, transport).then (results) ->
      results.rows[0].test.should.eql 'something'
      results.fields[0].name.should.eql 'test'
      done()

  it 'should perform a select with IN filter properly', (done) ->
    mockConnection.query  = (sql, cb) ->
      expected  = "SELECT `no_alias`, `alias` AS `test` " +
                  "FROM `test` " +
                  "WHERE `test` IN('foo','bar','baz') " +
                  "LIMIT 100 OFFSET 0"
      sql.should.equal expected
      cb null, [ { test: 'something' }], [{ name: 'test' }]

    transport.fields = [
      new FSPField 'no_alias'
      new FSPField 'alias', 'test'
    ]

    transport.filters = [
      new FSPFilter 'test', 'in', ['foo', 'bar','baz']
    ]

    query(mockConnection, transport).then (results) ->
      results.rows[0].test.should.eql 'something'
      results.fields[0].name.should.eql 'test'
      done()

  it 'should perform a sort query properly', (done) ->
    mockConnection.query = (sql, cb) ->
      expected  = "SELECT * FROM `test` " +
                  "ORDER BY `foo` ASC, `bar` DESC " +
                  "LIMIT 100 OFFSET 0"
      sql.should.equal expected
      cb null, [ { test: 'something' }], [{ name: 'test' }]

    transport.fields  = "ALL"
    transport.sorts   = FSPParser.sortQuery "foo|-bar"

    query(mockConnection, transport).then (results) ->
      results.rows[0].test.should.eql 'something'
      results.fields[0].name.should.eql 'test'
      done()

  it 'should perform a query with items', (done) ->
    mockConnection.query  = (sql, cb) ->
      expected  = "SELECT `no_alias`, `alias` AS `test` " +
        "FROM `test` " +
        "WHERE `test` IN('foo','bar','baz') " +
        "ORDER BY `foo` ASC, `bar` ASC, `baz` DESC " +
        "LIMIT 100 OFFSET 0"
      sql.should.equal expected
      cb null, [ { test: 'something' }], [{ name: 'test' }]

    transport.fields = [
      new FSPField 'no_alias'
      new FSPField 'alias', 'test'
    ]

    transport.filters = [
      new FSPFilter 'test', 'in', ['foo', 'bar','baz']
    ]

    transport.sorts   = FSPParser.sortQuery "foo|+bar|-baz"

    query(mockConnection, transport).then (results) ->
      results.rows[0].test.should.eql 'something'
      results.fields[0].name.should.eql 'test'
      done()