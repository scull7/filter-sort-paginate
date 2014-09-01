mysql         = require 'mysql'
FSPTransport  = requireTarget '/lib/transport'
FSPMySQL      = requireTarget '/lib/driver/mysql/'

describe 'FSPMySQL', ->
  transport       = null
  mockReq         = null
  mockConnection  = null

  beforeEach ->
    mockConnection  =
      escape: mysql.escape.bind(mysql)
      escapeId: mysql.escapeId.bind(mysql)

    mockReq         =
      mysql: mockConnection

    transport       = new FSPTransport 'test'

  it 'should be a function with an arity of 3', ->
    FSPMySQL.should.be.a 'function'
    FSPMySQL.length.should.equal 3

  it 'should set the items, field_data and total fields on the transport', (done) ->
    mockConnection.query = (sql, cb) ->
      if /SELECT \*/.test(sql)
        cb null, [{ test: 'something' }], [{ name: 'test' }]

      else if /SELECT COUNT/.test(sql)
        cb null, [{ count: 10 }]

      else
        throw Error("Bad SQL: #{sql}")

    FSPMySQL mockReq, transport, (err, results) ->
      expect(err).to.be.null
      results.items.should.eql [{ test: 'something' }]
      results.field_data.should.eql [{ name: 'test' }]
      results.total.should.eql 10
      done()

  it 'should catch and return any errors', (done) ->
    mockConnection.query = (sql, cb) ->
      if /SELECT \*/.test(sql)
        cb null, [{ test: 'something' }], [{ name: 'test' }]

      else if /SELECT COUNT/.test(sql)
        throw Error("COUNT ERROR");

      else
        throw Error("Bad SQL: #{sql}")

    FSPMySQL mockReq, transport, (err, results) ->
      err.message.should.eql "COUNT ERROR"
      done()
