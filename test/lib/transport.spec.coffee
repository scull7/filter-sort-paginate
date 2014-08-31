FSPTransport  = require __dirname + '/../../lib/transport'

describe 'FSPTransport', ->

  it 'should be a function with an arity of 1', ->
    FSPTransport.should.be.a 'function'
    FSPTransport.length.should.equal 1

  it 'should initialize with the given repository', ->
    test  = new FSPTransport 'my_repo'
    test.repository.should.equal 'my_repo'

  it 'should initialize to the proper defaults', ->
    test  = new FSPTransport 'test'
    test.repository.should.equal 'test'
    test.fields.should.eql []
    test.items.should.eql []
    test.total.should.equal 0
    test.sorts.should.eql []
    test.fields.should.eql []
    test.limit.should.equal 100
    test.page.should.equal 1