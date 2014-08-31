errors  = require __dirname + '/../../lib/error'

describe 'FSP Error Objects', ->
  FSPError          = errors.FSPError
  FSPParameterError = errors.FSPParameterError

  describe 'FSPError', ->

    it 'should be a function with an arity of 2', ->
      FSPError.should.be.a 'function'
      FSPError.length.should.equal 2

    it 'should format the message', ->
      test = new FSPError('unit_test', 'test %s %s', 'replace', 'more')
      test.message.should.equal "unit_test: test replace more"

  describe 'FSPParameterError', ->

    it 'should be a function', ->
      FSPParameterError.should.be.a 'function'

    it 'should inherit from FSPError', ->
      test = new FSPParameterError('unit_test', 'test')
      test.should.be.an.instanceOf errors.FSPError

    it 'should format the message', ->
      test = new FSPParameterError('unit_test', 'test %s %s', 'replace', 'more')
      test.message.should.equal "unit_test: test replace more"
