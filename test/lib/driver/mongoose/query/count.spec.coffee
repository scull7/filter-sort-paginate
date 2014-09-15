count         = rewireTarget '/lib/driver/mongoose/query/count'
FSPTransport  = requireTarget '/lib/transport'
FSPFilter     = requireTarget '/lib/filter'

describe "FSP Mongoose Query Count", ->
  mongoose  = null
  query     = null
  transport = null
  repo      = null

  beforeEach ->
    repo      = 'test_repo'
    transport = new FSPTransport(repo)

    mongoose  = {
      model: sinon.stub()
    }

    query     = {
      count: sinon.stub()
      find: sinon.stub()
      exec: sinon.stub()
      equals: sinon.stub()
      gte: sinon.stub()
      where: sinon.stub()
    }

    mongoose.model.returns(query)

    Object.keys(query).forEach (method) ->
      query[method].returns(query)

  it "should be a function with an arity of 2", ->
    count.should.be.a 'function'
    count.length.should.eql 2

  it "should call the count function when a base transport is given", (done) ->
    query.count.callsArgWith(0, null, 100)

    count(mongoose, transport).then (count) ->
      mongoose.model.calledWith(repo).should.be.true
      mongoose.model.calledOnce.should.be.true
      query.find.calledOnce.should.be.true
      count.should.eql 100
      done()

  it "should add in filters when present", (done) ->
    transport.filters = [
      new FSPFilter('col1', 'is','val1')
      new FSPFilter('col2', 'gte', 'val2')
      new FSPFilter('col3', 'equals', 'val3')
    ]

    query.count.callsArgWith(0, null, 101)

    count(mongoose, transport).then (count) ->
      query.equals.calledWith('val1').should.be.true
      query.equals.calledWith('val3').should.be.true
      query.equals.calledTwice.should.be.true
      query.gte.calledWith('val2').should.be.true
      query.gte.calledOnce.should.be.true
      query.where.calledWith('col1').should.be.true
      query.where.calledWith('col2').should.be.true
      query.where.calledWith('col3').should.be.true
      query.where.calledThrice.should.be.true
      count.should.eql 101
      done()

  it "should reject the promise if an error occurs in the query", (done) ->
    query.count.callsArgWith(0, 'count_error')
    success = sinon.stub()

    count(mongoose, transport).then(success)
      .catch (err) ->
        err.should.eql 'count_error'
        success.called.should.be.false
        done()
