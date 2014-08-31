FSPSort           = require __dirname + '/../../lib/sort'
FSPParameterError = require(__dirname + '/../../lib/error').FSPParameterError

describe 'FSPSort', ->

  it 'should be a function with an arity of 2', ->
    FSPSort.should.be.a 'function'
    FSPSort.length.should.equal 2

  it 'should throw an exception if an invalid column name is given', ->
    test = () -> new FSPSort('-bad')
    expect(test).to.throw FSPParameterError
    expect(test).to.throw /FSPSort: Invalid column name: -bad/

  it 'should throw an exception if an invalid direction is given', ->
    test = () -> new FSPSort('good', '-bad')
    expect(test).to.throw FSPParameterError
    expect(test).to.throw /FSPSort: Invalid direction: -bad/

  it 'should set the direction to "+" if a direction is not provided', ->
    test  = new FSPSort('good')
    test.direction.should.equal '+'

  it 'should set the column name to the given name if valid', ->
    test = new FSPSort('good')
    test.column.should.equal 'good'

  it 'should set the direction to "-" if the direction is DESC', ->
    test  = new FSPSort('good', 'DESC')
    test.direction.should.equal '-'

  it 'should set the direction to "+" if the direction is ASC', ->
    test  = new FSPSort('good', 'ASC')
    test.direction.should.equal '+'

  it 'should set the direction to "-" if the direction given is "-"', ->
    test = new FSPSort('good', '-')
    test.direction.should.equal '-'

  it 'should set the direction to "+" if the direction given is "+"', ->
    test = new FSPSort('good', '+')
    test.direction.should.equal '+'