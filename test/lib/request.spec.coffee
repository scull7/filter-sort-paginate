FSPRequest  = require __dirname + '/../../lib/request'

describe 'FSPRequest', ->
  mockReq = null

  beforeEach ->
    mockReq =
      query: {}

  it 'should be a function with an arity of 2', ->
    FSPRequest.should.be.a 'function'
    FSPRequest.length.should.equal 2

  it 'should return the given transport unchanged if the query is not present', ->
    transport =
      page: 10
      limit: 1000

    mockReq.query = null

    test  = FSPRequest(mockReq, transport)
    test.page.should.equal 10
    test.limit.should.equal 1000

  it 'should set the page and limit to the default values if not provided', ->
    transport =
      page: 10
      limit: 1000

    test  = FSPRequest(mockReq, transport)
    test.page.should.equal 1
    test.limit.should.equal 100

  it 'should set the page and limit to the provided values', ->
    transport =
      page: 10
      limit: 1000

    mockReq.query =
      page: 9
      limit: 25

    test  = FSPRequest(mockReq, transport)
    test.page.should.equal 9
    test.limit.should.equal 25

  it 'should parse and set filter values', ->
    mockReq.query =
      filter: 'foo:is:25|bar:like:baz'

    test  = FSPRequest(mockReq, {})
    test.filters.should.be.a 'Array'
    test.filters.should.deep.equal [
      { column: 'foo', action: 'is', value: '25' }
      { column: 'bar', action: 'like', value: 'baz' }
    ]

  it 'should parse and set sort values', ->
    mockReq.query =
      sort: '-foo|bar|+baz'

    test  = FSPRequest(mockReq, {} )
    test.sorts.should.be.a 'Array'
    test.sorts.should.be.deep.equal [
      { column: 'foo', direction: '-' }
      { column: 'bar', direction: '+' }
      { column: 'baz', direction: '+' }
    ]
