FSPMySQLQueryList = requireTarget '/lib/driver/mysql/query/list'

describe 'FSPMySQLQueryList', ->

  it 'should be a function with an arity of 2', ->
    FSPMySQLQueryList.should.be.a 'function'
    FSPMySQLQueryList.length.should.equal 2