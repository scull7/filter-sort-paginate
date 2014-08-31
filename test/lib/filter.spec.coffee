FSPFilter         = require __dirname + '/../../lib/filter'
FSPParameterError = require(__dirname + '/../../lib/error').FSPParameterError

describe 'FSPFilter', ->

  it 'should be a function with an arity of 3', ->
    FSPFilter.should.be.a 'function'
    FSPFilter.length.should.equal 3


  it 'should throw an exception if an invalid column name is given', ->
    test = () -> new FSPFilter('-bad')
    expect(test).to.throw FSPParameterError
    expect(test).to.throw /FSPFilter: Invalid Column: -bad/

  it 'should throw an exception if an invalid action is given', ->
    test = () -> new FSPFilter('good', '-bad')
    expect(test).to.throw FSPParameterError
    expect(test).to.throw /FSPFilter: Invalid Action: -bad/

  it 'should throw an exception if an value is not defined', ->
    test = () -> new FSPFilter('good', 'is')
    expect(test).to.throw FSPParameterError
    expect(test).to.throw /FSPFilter: Value is required/

  it 'should not throw an error for all valid actions', ->
    FSPFilter.actions.forEach (action) ->
      test = new FSPFilter('good', action, 'test')
      test.column.should.equal 'good'
      test.action.should.equal action
      test.value.should.equal 'test'

  it 'should set the column to the given column name', ->
    test = new FSPFilter('my_column', 'is', 'test')
    test.column.should.equal 'my_column'

  it 'should set the action to the given action name', ->
    test = new FSPFilter('my_column', 'is', 'test')
    test.action.should.equal 'is'

  it 'should set the value to the given value', ->
    test = new FSPFilter('my_column', 'is', 'test')
    test.value.should.equal 'test'
