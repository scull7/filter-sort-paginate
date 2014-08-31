mysql               = require 'mysql'
FSPParser           = requireTarget '/lib/request/parsers'
FSPTransport        = requireTarget '/lib/transport'
FSPMySQLQueryCount  = requireTarget '/lib/driver/mysql/query/count'

describe 'FSPMySQLQueryCount', ->
  query           = FSPMySQLQueryCount
  transport       = null
  mockConnection  = null

  beforeEach ->
    mockConnection  =
      escape: mysql.escape.bind(mysql)
      escapeId: mysql.escapeId.bind(mysql)

    transport       = new FSPTransport('test')

  it 'should be a function with an arity of 2', ->
    FSPMySQLQueryCount.should.be.a 'function'
    FSPMySQLQueryCount.length.should.equal 2

  it 'should perform a no filter query properly', (done) ->
    mockConnection.query = (sql, cb) ->
      sql.should.equal "SELECT COUNT(*) AS `count` FROM `test`"
      cb null, [{ count: 100 }]

    query(mockConnection, transport).then (count) ->
      count.should.equal 100
      done()

  it 'should bubble up an error if it receives one', (done) ->
    mockConnection.query  = (sql, cb) ->
      cb "bad juju"

    spy = sinon.spy()

    query(mockConnection, transport).then(spy).catch( (err) ->
      err.should.equal "bad juju"
      spy.called.should.be.false
      done()
    )

  it 'should perform a query with a filter properly', (done) ->
    filters = FSPParser.filterQuery 'isTest:is:something|a:lt:22'
    transport.filters = filters

    mockConnection.query  = (sql, cb) ->
      sql.should.equal(
        "SELECT COUNT(*) AS `count` FROM `test` " +
        "WHERE `isTest` = 'something' AND `a` < '22'"
      )
      cb null, [{ count: 25 }]

    query(mockConnection, transport).then (count) ->
      count.should.equal 25
      done()