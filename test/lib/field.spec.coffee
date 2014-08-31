FSPField  = require __dirname + '/../../lib/field'
FSPParameterError = require(__dirname + '/../../lib/error')

describe 'FSPField', ->

  it 'should be a function with an arity of 2', ->
    FSPField.should.be.a 'function'
    FSPField.length.should.equal 2

  it 'should throw an error if the column name is invalid', ->
    test = () -> new FSPField('-badNam3')
    expect(test).to.throw FSPParameterError
    expect(test).to.throw /FSPField: Invalid field name: -badNam3/

  it 'should set the name of the field to the given name', ->
    test = new FSPField('my_name')
    test.should.be.an.instanceOf FSPField
    test.name.should.equal 'my_name'

  it 'should set the alias of the field to null if an alias is not provided', ->
    test = new FSPField('my_name')
    test.should.be.an.instanceOf FSPField
    test.name.should.equal 'my_name'
    expect(test.alias).to.be.null

  it 'should set the alias of the field to the given value', ->
    test = new FSPField('my_name', 'my_alias')
    test.should.be.an.instanceOf FSPField
    test.name.should.equal 'my_name'
    expect(test.alias).to.equal 'my_alias'

  describe 'getManyFromArray', ->

    it 'should be a function with an arity of 1', ->
      FSPField.getManyFromArray.should.be.a 'function'
      FSPField.getManyFromArray.length.should.equal 1

    it 'should throw a TypeError if a non array value is given', ->
      ['boo', 123, {}, { test: 'boo'}, /test/, null ].forEach (item) ->
        test = () -> FSPField.getManyFromArray(item)
        expect(test).to.throw FSPParameterError
        expect(test).to.throw /FSPField::getManyFromArray: Invalid fields parameter:/

    it 'should return an empty array if an empty array is given', ->
      test = FSPField.getManyFromArray([])
      test.should.deep.equal []

    it 'should return an array of FSPFields that represents the given array', ->
      fields = [
        { name: 'test', alias: 'my_test' }
        { name: 'no_alias' }
        { name: 'has_alias', alias: 'this' }
      ]
      test  = FSPField.getManyFromArray(fields)

      test.forEach (field) -> field.should.be.an.instanceOf FSPField

      test[0].name.should.equal 'test'
      test[0].alias.should.equal 'my_test'
      test[1].name.should.equal 'no_alias'
      expect(test[1].alias).to.be.null
      test[2].name.should.equal 'has_alias'
      test[2].alias.should.equal 'this'