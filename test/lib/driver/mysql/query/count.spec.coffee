FSPMySQLQueryCount = requireTarget '/lib/driver/mysql/query/count'

describe 'FSPMySQLQueryCount', ->

  it 'should be a function with an arity of 2', ->
    FSPMySQLQueryCount.should.be.a 'function'
    FSPMySQLQueryCount.length.should.equal 2