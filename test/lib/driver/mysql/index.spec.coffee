FSPMySQL  = requireTarget '/lib/driver/mysql/'

describe 'FSPMySQL', ->

  it 'should be a function with an arity of 3', ->
    FSPMySQL.should.be.a 'function'
    FSPMySQL.length.should.equal 3