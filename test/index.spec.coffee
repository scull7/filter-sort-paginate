mysql             = require 'mysql'
FSPField          = require __dirname + '/../lib/field'
FSPFactory        = require __dirname + '/../index'
FSPParameterError = requireTarget('/lib/error').FSPParameterError

describe 'FSPFactory', ->
  mockReq         = null
  mockConnection  = null

  beforeEach ->
    mockConnection =
      escape: mysql.escape.bind(mysql)
      escapeId: mysql.escapeId.bind(mysql)
    mockReq =
      mysql: mockConnection

  it 'should be a function with an arity of 3', ->
    FSPFactory.should.be.a 'function'
    FSPFactory.length.should.equal 3

  it 'should return a middleware function with an arity of 3', ->
    test = FSPFactory('test')
    test.should.be.a 'function'
    test.length.should.equal 3

  it 'should throw an exception if an invalid driver is specified', ->
    test  = () -> return FSPFactory('test', [], { driver: 'bad' })
    expect(test).to.throw FSPParameterError
    expect(test).to.throw /Invalid Driver Specified: bad/

  describe 'FSPMiddleware', ->

    it 'should call the set driver with the transport and request', (done) ->
      driver = (req, transport, cb) ->
        req.test.should.equal 'something'
        return cb(null, transport)

      mockReq.test = 'something'

      mockRes =
        json: (response) ->
          response.repository.should.equal 'middleware'
          done()

      FSPFactory.addDriver 'test-middleware', driver
      test = FSPFactory 'middleware', [], { driver: 'test-middleware' }
      test(mockReq, mockRes)

    it 'should call next(err) if an error occurs in the driver', (done) ->
      driver  = (req, transport, cb) -> return cb('test error')
      mockRes = {}

      FSPFactory.addDriver 'test-mw-error', driver
      test    = FSPFactory 'test-mw-error', [], { driver: 'test-mw-error' }
      test mockReq, mockRes, (err) ->
        err.should.equal 'test error'
        done()

    it 'should parse things out of the request', (done) ->
      driver  = (req, transport, cb) -> return cb(null, transport)

      fields  = [
        'test'
        'this'
        'that'
      ]

      mockReq.query =
        filter: "test:is:something|this:gt:that"
        sort: "-test|+this"
        page: 2
        limit: 25

      mockRes =
        json: (response) ->
          response.repository.should.equal 'request'
          response.limit.should.equal 25
          response.page.should.equal 2
          response.fields.should.deep.equal [
            { name: 'test', alias: null }
            { name: 'this', alias: null }
            { name: 'that', alias: null }
          ]
          response.sorts.should.deep.equal [
            { column: 'test', direction: '-' }
            { column: 'this', direction: '+' }
          ]
          response.filters.should.deep.equal [
            { column: 'test', action: 'is', value: 'something' }
            { column: 'this', action: 'gt', value: 'that' }
          ]
          done()

      FSPFactory.addDriver 'test-request', driver
      test    = FSPFactory 'request', fields, { driver: 'test-request' }
      test mockReq, mockRes

  describe 'addDriver()', ->

    it 'should throw an exception if a name is not provided', ->
      test  = () -> FSPFactory.addDriver null, () ->

      expect(test).to.throw FSPParameterError
      expect(test).to.throw /You must specify a driver name/

    it 'should throw an exception if the driver is not a function', ->
      test  = () -> FSPFactory.addDriver 'bad_driver', 'bad'

      expect(test).to.throw FSPParameterError
      expect(test).to.throw /Driver must be a function/

    it 'should allow the setting of a new driver', (done) ->
      driver  = (req, transport) ->
        transport.fields.should.eql []
        transport.repository.should.equal 'driver_test'
        done()

      FSPFactory.addDriver('test', driver)

      test  = FSPFactory 'driver_test', [], { driver: 'test' }
      test mockReq, {}, () ->