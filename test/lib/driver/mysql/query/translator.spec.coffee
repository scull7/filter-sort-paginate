mysql                   = require 'mysql'
FSPField                = requireTarget '/lib/field'
FSPFilter               = requireTarget '/lib/filter'
FSPSort                 = requireTarget '/lib/sort'
FSPParser               = requireTarget '/lib/request/parsers'
FSPParameterError       = requireTarget('/lib/error').FSPParameterError
FSPMySQLQueryTranslator = requireTarget '/lib/driver/mysql/query/translator'

describe 'FSPMySQLQueryTranslator', ->
  translator      = null
  mockConnection  = null

  beforeEach ->
    mockConnection  =
      escape: mysql.escape.bind(mysql)
      escapeId: mysql.escapeId.bind(mysql)

    translator      = new FSPMySQLQueryTranslator(mockConnection)

  it 'should be a function with an arity of 1', ->
    FSPMySQLQueryTranslator.should.be.a 'function'
    FSPMySQLQueryTranslator.length.should.equal 1


  describe 'render()', ->

    it 'should be a function with an arity of 2', ->
      FSPMySQLQueryTranslator.prototype.render.should.be.a 'function'
      FSPMySQLQueryTranslator.prototype.render.length.should.equal 2

    it 'should replace :<name> tokens within the template', ->
      template  = ":replace :me but not me :me and not me but :replace this"
      expected  = 'REPLACE ME but not me ME and not me but REPLACE this'
      values    =
        'replace': 'REPLACE'
        'me': 'ME'
        'bad': 'NOT ME'

      translator.render(template, values).should.equal expected

  describe 'fields()', ->

    it 'should be a function with an arity of 1', ->
      FSPMySQLQueryTranslator.prototype.fields.should.be.a 'function'
      FSPMySQLQueryTranslator.prototype.fields.length.should.equal 1

    it 'should throw a FSPParameterError is the fields parameter is not valid', ->
      test  = (param) ->
        return translator.fields.bind(translator, param)

      params  = [null, undefined, 123, { field: 'test' }, 'boo', /something/]

      params.forEach (param) ->
        expect(test(param)).to.throw FSPParameterError
        expect(test(param)).to.throw(
          /FSPMySQLTranslator::fields\(\): fields parameter is not valid:/
        )

    it 'should return "SELECT *" if "*" is passed in', ->
      translator.fields('*').should.equal 'SELECT *'

    it 'should return "SELECT *" if "ALL" or "all" is passed in', ->
      translator.fields('ALL').should.equal 'SELECT *'
      translator.fields('all').should.equal 'SELECT *'

    it 'should parse and sanitize all fields in the given array', ->
      fields  = [
        new FSPField 'foo', 'bar'
        new FSPField 'baz', 'buzz'
        new FSPField 'yay', 'boo'
        new FSPField 'test'
      ]

      expected  = 'SELECT `foo` AS `bar`, `baz` AS `buzz`, `yay` AS `boo`, `test`'

      translator.fields(fields).should.equal expected

  describe 'filters()', ->

    it 'should be a function with an arity of 1', ->
      FSPMySQLQueryTranslator.prototype.filters.should.be.a 'function'
      FSPMySQLQueryTranslator.prototype.filters.length.should.equal 1

    it 'should throw an FSPParameterError if the filters parameter is not an array', ->
      test  = (param) ->
        return translator.filters.bind(translator, param)

      params  = [null, undefined, 123, { field: 'test' }, 'boo', /something/]

      params.forEach (param) ->
        expect(test(param)).to.throw FSPParameterError
        expect(test(param)).to.throw(
          /FSPMySQLTranslator::filters\(\): filters parameter is not valid:/
        )

    it 'should throw an FSPParameterError if an invalid filter is in the passed array', ->
      tryFilter  = (bad) ->
        filters = [
          new FSPFilter('test', 'in', ['foo','bar','baz'])
          new FSPFilter('c', 'is', 'something')
          bad
        ]
        return translator.filters.bind(translator, filters)

      tests = [
        null
        undefined
        123
        { column: 'good', action: 'invalid', value: 'boo' }
        /something/
      ]

      tests.forEach (test) ->
        expect(tryFilter(test)).to.throw FSPParameterError
        expect(tryFilter(test)).to.throw(
          /FSPMySQLTranslator::filters\(\): filter is not valid:/
        )

    it 'should render the given filters appropriately', ->
      query     = "test:is:something|something:equals:test"
      filters   = FSPParser.filterQuery(query)
      expected  = " WHERE `test` = 'something' AND `something` = 'test'"

      translator.filters(filters).should.equal expected

    it 'should render an in query appropriately', ->
      filters = [
        new FSPFilter('inTest', 'in', ['foo', 'bar','baz'])
        new FSPFilter('isTest', 'is', 'something')
      ]
      expected = " WHERE `inTest` IN('foo','bar','baz') AND `isTest` = 'something'"

      translator.filters(filters).should.equal expected

  describe 'sorts()', ->

    it 'should be a function with an arity of 1', ->
      FSPMySQLQueryTranslator.prototype.sorts.should.be.a 'function'
      FSPMySQLQueryTranslator.prototype.sorts.length.should.equal 1

    it 'should throw an FSPParameterError if the sorts parameter is not an array', ->
      test  = (param) ->
        return translator.sorts.bind(translator, param)

      params  = [null, undefined, 123, { field: 'test' }, 'boo', /something/]

      params.forEach (param) ->
        expect(test(param)).to.throw FSPParameterError
        expect(test(param)).to.throw(
          /FSPMySQLTranslator::sorts\(\): sorts parameter is not valid:/
        )

    it 'should throw an FSPParameterError if an invalid sort is in the passed array', ->
      trySort  = (bad) ->
        sorts = [
          new FSPSort('test', 'ASC')
          new FSPSort('desc', 'DESC')
          bad
        ]
        return translator.sorts.bind(translator, sorts)

      tests = [
        null
        undefined
        123
        { column: 'good', direction: '+' }
        /something/
      ]

      tests.forEach (test) ->
        expect(trySort(test)).to.throw FSPParameterError
        expect(trySort(test)).to.throw(
          /FSPMySQLTranslator::sorts\(\): sort is not valid:/
        )

    it 'should return an empty string if no sorts are passed', ->
      translator.sorts([]).should.equal ""

    it 'should return a properly formatted single ORDER BY statement', ->
      sorts = [ new FSPSort('baz', 'DESC') ]
      translator.sorts(sorts).should.equal " ORDER BY `baz` DESC"

    it 'should return a properly formatted multiple ORDER BY statement', ->
      sorts = FSPParser.sortQuery "foo|-bar"
      translator.sorts(sorts).should.equal " ORDER BY `foo` ASC, `bar` DESC"

  describe 'page()', ->

    it 'should be a function with an arity of 2', ->
      FSPMySQLQueryTranslator.prototype.page.should.be.a 'function'
      FSPMySQLQueryTranslator.prototype.page.length.should.equal 2

    it 'should throw an FSPParameterError if the page parameter is not an array', ->
      test  = (param) ->
        return translator.page.bind(translator, param, 100)

      params  = [null, undefined, [], { field: 'test' }, 'boo', /something/]

      params.forEach (param) ->
        expect(test(param)).to.throw FSPParameterError
        expect(test(param)).to.throw(
          /FSPMySQLTranslator::page\(\): page parameter is not valid:/
        )

    it 'should throw an FSPParameterError if the row_count parameter is not an array', ->
      test  = (param) ->
        return translator.page.bind(translator, 0, param)

      params  = [null, undefined, [], { field: 'test' }, 'boo', /something/]

      params.forEach (param) ->
        expect(test(param)).to.throw FSPParameterError
        expect(test(param)).to.throw(
          /FSPMySQLTranslator::page\(\): row_count parameter is not valid:/
        )

    it 'should throw an exception if page is less than 1', ->
      test  = (param) ->
        return translator.page.bind(translator, param, 100)

      params  = [-1, 0, -100, -4]

      params.forEach (param) ->
        expect(test(param)).to.throw FSPParameterError
        expect(test(param)).to.throw(
          /FSPMySQLTranslator::page\(\): page parameter must be greater than one \(1\):/
        )

    it 'should return a page one (1) query properly', ->
      test  = translator.page(1, 100);
      test.should.equal " LIMIT 100 OFFSET 0"

    it 'should return an "n" page query properly', ->
      expected  = " LIMIT 25 OFFSET 25"
      translator.page(2, 25).should.equal expected

      expected  = " LIMIT 25 OFFSET 75"
      translator.page(4, 25).should.equal expected