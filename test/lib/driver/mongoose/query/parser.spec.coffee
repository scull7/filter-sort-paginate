parser  = requireTarget '/lib/driver/mongoose/query/parser'

describe "FSP Mongoose Parser", ->

  describe "filter", ->
    query   = null
    filter  = null

    beforeEach ->
      query = {
        where: sinon.stub()
        is: sinon.stub()
        equals: sinon.stub()
        lt: sinon.stub()
        lte: sinon.stub()
        gt: sinon.stub()
        gte: sinon.stub()
        in: sinon.stub()
      }

      filter  = {
        column: 'test_column'
        value: 'test_value'
      }

    it "should call the proper method on the query", ->
      methods = ['lt','lte','gt','gte','equals', 'in']
      query.where.withArgs('test_column').returns(query)

      methods.forEach (method) ->
        filter.action = method
        query[method].withArgs('test_value').returns method+'_expected'

        actual  = parser.filter(query, filter)
        actual.should.equal method+'_expected'

    it "should call the equals method on the query when the value is 'is'", ->
      filter.action   = 'is'
      query.where.withArgs('test_column').returns(query)
      query.equals.withArgs('test_value').returns('expected')

      actual  = parser.filter(query, filter)
      actual.should.eql 'expected'

    it "should call the equals method on the query when the action is 'equals'", ->
      filter.action   = 'equals'
      query.where.withArgs('test_column').returns(query)
      query.equals.withArgs('test_value').returns('expected')

      actual  = parser.filter(query, filter)
      actual.should.eql 'expected'

    it "should call the where method with a regex with the action is like", ->
      filter.action   = 'like'
      regex           = new RegExp(filter.value)
      query.where.withArgs('test_column', regex).returns 'like_expected'

      actual  = parser.filter(query, filter)
      actual.should.eql 'like_expected'
      query.where.calledWith('test_column', regex).should.be.true

    it "should call the where method with a regex when the action is starts", ->
      filter.action   = 'starts'
      regex           = new RegExp('^' + filter.value)
      query.where.withArgs('test_column', regex).returns 'starts_expected'

      actual  = parser.filter(query, filter)
      actual.should.equal 'starts_expected'
      query.where.calledWith('test_column', regex).should.be.true

    it "should call the where method with a regex when the action is ends", ->
      filter.action   = 'ends'
      regex           = new RegExp(filter.value + '$')
      query.where.withArgs('test_column', regex).returns 'ends_expected'

      actual  = parser.filter(query, filter)
      actual.should.equal 'ends_expected'
      query.where.calledWith('test_column', regex).should.be.true


