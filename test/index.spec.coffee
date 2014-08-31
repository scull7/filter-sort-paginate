FSPField    = require __dirname + '/../lib/field'
FSPFactory  = require __dirname + '/../index'

describe 'FSPFactory', ->

  it 'should be a function with an arity of 3', ->
    FSPFactory.should.be.a 'function'
    FSPFactory.length.should.equal 3

  it 'should set the repository name and fields to the given items', ->
    fields = [
      { name: 'test1', alias: 'alias1' }
      { name: 'test2' }
    ]
    test = new FSPFactory('repo', fields)

    test.repository.should.equal 'repo'
    test.fields[0].should.be.an.instanceof FSPField