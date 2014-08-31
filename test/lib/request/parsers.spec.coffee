parsers   = require __dirname + '/../../../lib/request/parsers'

describe 'FSP Parsers', ->

  describe 'filterQuery', ->
    filterQuery   = parsers.filterQuery
    filterParser  = null

    beforeEach ->
      filterParser  = (string) -> return filterQuery.bind filterQuery, string

    it 'should be a function with an arity of 2', ->
      filterQuery.should.be.a 'function'
      filterQuery.length.should.equal 2

    it "should throw an exception with an invalid token", ->
      test = filterParser "c:is:v|c:"

      expect(test).to.throw Error
      expect(test).to.throw /Invalid filter token: c: in string: c:a:v|c:/

    it 'should return an array of filter objects', ->
      results = filterQuery "c:is:v|g:lt:f"

      results.length.should.equal 2
      results[0].column.should.equal 'c'
      results[0].action.should.equal 'is'
      results[0].value.should.equal 'v'

      results[1].column.should.equal 'g'
      results[1].action.should.equal 'lt'
      results[1].value.should.equal 'f'

  describe 'sortQuery', ->
    sortQuery   = parsers.sortQuery
    sortParser  = null

    beforeEach ->
      sortParser  = (string) -> return sortQuery.bind sortQuery, string

    it 'should be a function with an arity of 2', ->
      sortQuery.should.be.a 'function'
      sortQuery.length.should.equal 2

    it 'should throw an exception with an invalid token', ->
      test = sortParser '-col1|*column'
      expect(test).to.throw Error
      expect(test).to.throw /Invalid sort token: \*column in string: \-col1|\*column/

    it 'should throw an exception with a duplicate column', ->
      test  = sortParser '-col1|+col2|+col1'
      expect(test).to.throw Error

    it 'should return an array of sort objects', ->
      results   = sortQuery '-col1|+col2|+col3|-col_4|col5|+col6'

      expected  = [
        { column: 'col1', direction: '-' }
        { column: 'col2', direction: '+' }
        { column: 'col3', direction: '+' }
        { column: 'col_4', direction: '-' }
        { column: 'col5', direction: '+' }
        { column: 'col6', direction: '+' }
      ]

      results.length.should.equal 6
      results.should.deep.equal expected