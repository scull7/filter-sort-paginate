list          = rewireTarget '/lib/driver/mongoose/query/list'
FSPTransport  = requireTarget '/lib/transport'
FSPFilter     = requireTarget '/lib/filter'
FSPSort       = requireTarget '/lib/sort'

describe "FSP Mongoose Query List", ->
  mongoose  = null
  query     = null
  transport = null
  repo      = null

  beforeEach ->
    repo      = "test_repo"
    transport = new FSPTransport(repo)

    mongoose  = {
      model: sinon.stub()
    }

    query     = {
      find: sinon.stub()
      sort: sinon.stub()
      limit: sinon.stub()
      skip: sinon.stub()
      exec: sinon.stub()
      equals: sinon.stub()
      lt: sinon.stub()
      where: sinon.stub()
    }

    mongoose.model.returns(query)

    Object.keys(query).forEach (method) ->
      query[method].returns(query)

  it "should be a function with an arity of 2", ->
    list.should.be.a 'function'
    list.length.should.eql 2

  it "should perform an all query properly", (done) ->
    query.exec.callsArgWith(0, null, 'test')
    
    list(mongoose, transport).then ( data ) ->
      mongoose.model.calledWith(repo).should.be.true
      query.limit.calledWith(100).should.be.true
      query.limit.calledOnce.should.be.true

      query.skip.calledWith(0).should.be.true
      query.skip.calledOnce.should.be.true

      data.should.eql { rows: 'test' }
      done()

  it "should apply filters properly", (done) ->
    transport.filters = [
      new FSPFilter('test1', 'is', 'value1')
      new FSPFilter('test2', 'lt', 'value2')
    ]

    query.exec.callsArgWith(0, null, 'test')

    list(mongoose, transport).then ( data ) ->
      query.equals.calledWith('value1').should.be.true
      query.lt.calledWith('value2').should.be.true
      data.should.eql { rows: 'test' }
      done()

  it "should apply sorts properly", (done) ->
    transport.sorts = [
      new FSPSort('test1', 'ASC')
      new FSPSort('test2', 'DESC')
      new FSPSort('test3')
    ]

    query.exec.callsArgWith(0, null, 'sorts')

    list(mongoose, transport).then ( data ) ->
      query.sort.calledWith('+test1').should.be.true
      query.sort.calledWith('-test2').should.be.true
      query.sort.calledWith('+test3').should.be.true
      data.should.eql { rows: 'sorts' }
      done()

  it "should reject the promise on an error", (done) ->
    query.exec.callsArgWith(0, 'error')
    success = sinon.stub()

    list(mongoose, transport).then(success)
      .catch (err) ->
        err.should.eql 'error'
        success.called.should.be.false
        done()
