mysql             = require 'mysql'
FSPField          = require __dirname + '/../lib/field'
FSPFactory        = require __dirname + '/../index'
FSPParameterError = requireTarget('/lib/error').FSPParameterError

describe 'FSPFactory', ->
  mockReq         = null
  mockConnection  = null



  it 'should be a function with an arity of 3', ->
    FSPFactory.should.be.a 'function'
    FSPFactory.length.should.equal 3

  it 'should throw an exception if an invalid driver is specified', ->
    test  = () -> return FSPFactory('test', [], { driver: 'bad' })
    expect(test).to.throw FSPParameterError
    expect(test).to.throw /Invalid Driver Specified: bad/

  it 'should set the repository name and fields to the given items', ->
    fields = [
      { name: 'test1', alias: 'alias1' }
      { name: 'test2' }
    ]
    test = FSPFactory('repo', fields)

