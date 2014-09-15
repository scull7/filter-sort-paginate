Promise         = require('bluebird')
driver          = rewireTarget '/lib/driver/mongoose/index'
FSPTransport    = requireTarget '/lib/transport'

describe "FSP Mongoose Driver", ->
  transport = null
  mockReq   = null
  list      = null
  count     = null

  beforeEach ->
    transport = new FSPTransport('test_repo') 
    list      = sinon.stub()
    count     = sinon.stub()

    driver.__set__('FSPMongooseQueryList', list)
    driver.__set__('FSPMongooseQueryCount', count)

    count_promise = new Promise (resolve) -> resolve(100)
    count.returns(count_promise)

    mockReq   = {
      mongoose: {}
    }

  it "should be a function with an arity of 3", ->
    driver.should.be.a 'function'
    driver.length.should.eql 3

  it "should call the done function with a filled in transport", (done) ->
    list_promise  = new Promise (resolve) -> resolve({rows: 'test_rows'})
    list.returns(list_promise)

    driver mockReq, transport, (err, results) ->
      transport.items = { rows: 'test_rows' }
      transport.total = 100
      done()

  it "should call done with an error if the list throws an error", (done) ->
    list_promise  = new Promise (resolve, reject) -> reject ('list_error')
    list.returns(list_promise)

    driver mockReq, transport, (err) ->
      err.should.eql 'list_error'
      done()
