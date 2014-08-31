validators  = require __dirname + '/../../lib/validators'

describe 'Validators', ->

  describe 'isColumnName', ->

    it 'should return false if the name starts with an _', ->
      validators.isColumnName('_test').should.be.false

    it 'should return false if the name starts with a number', ->
      validators.isColumnName('1test').should.be.false

    it 'should return false if the name contains a special character', ->
      validators.isColumnName('test&').should.be.false
      validators.isColumnName('1te*st').should.be.false
      validators.isColumnName('1te?st').should.be.false
      validators.isColumnName('-bad').should.be.false

    it 'should return true if the name is valid', ->
      validators.isColumnName('test_column').should.be.true
      validators.isColumnName('testColumn').should.be.true
      validators.isColumnName('test').should.be.true
      validators.isColumnName('t1est_column').should.be.true
      validators.isColumnName('test1Column').should.be.true
      validators.isColumnName('test1').should.be.true

    it 'should allow a single character column', ->
      validators.isColumnName('c').should.be.true

  describe 'isSortDirection', ->

    it 'should return true if a valid direction is given', ->
      valid = ['ASC', '+', 'DESC', '-']
      valid.forEach (test) ->
        validators.isSortDirection(test).should.be.true

    it 'should return false if an invalid direction is given', ->
      invalid = ['test', 'bad', 123, [], {}, null]
      invalid.forEach (test) ->
        validators.isSortDirection(test).should.be.false

  describe 'isFilterAction', ->

    it 'should return true if a valid direction is given', ->
      valid = ["equals","is","lt","lte","gt","gte","like","starts","ends", "in"]
      valid.forEach (test) ->
        validators.isFilterAction(test).should.be.true

    it 'should return false if an invalid direction is given', ->
      invalid = ['test', 'bad', 123, [], {}, null]
      invalid.forEach (test) ->
        validators.isFilterAction(test).should.be.false