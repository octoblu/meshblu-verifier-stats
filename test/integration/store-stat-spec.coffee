{beforeEach, afterEach, describe, it} = global
{expect}      = require 'chai'
_             = require 'lodash'
moment        = require 'moment'
request       = require 'request'
sinon         = require 'sinon'
Server        = require '../../src/server'

describe 'Hello', ->
  beforeEach (done) ->
    @elasticsearch = create: sinon.stub()

    @logFn = sinon.spy()
    serverOptions = {
      @elasticsearch,
      @logFn,
      elasticsearchIndex: 'stats'
      port: undefined,
      disableLogging: true
      username: 'jordan'
      password: 'patterson'
    }

    @server = new Server serverOptions

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach (done) ->
    @server.destroy done

  describe 'On POST /stats/duck', ->
    beforeEach (done) ->
      @elasticsearch.create.yields null

      options =
        uri: '/stats/duck'
        baseUrl: "http://localhost:#{@serverPort}"
        auth:
          username: 'jordan'
          password: 'patterson'
        json: {
          operation: 'nerba'
          startTime: '1955-04-01T01:00:00Z'
          endTime:   '1955-04-01T02:00:00Z'
        }

      request.post options, (error, @response, @body) =>
        done error

    it 'should return a 201', ->
      expect(@response.statusCode).to.equal 201, @body

    it 'should insert the request into elasticsearch', ->
      dateStr = moment().format "YYYY-MM-DD"

      expect(@elasticsearch.create).to.have.been.called

      arg = _.first @elasticsearch.create.firstCall.args
      now = moment()

      expect(arg).to.containSubset {
        index: "stats:#{dateStr}"
        type: 'duck'
        body: {
          index: "stats:#{dateStr}"
          type: 'duck'
          operation: 'nerba'
          startTime: '1955-04-01T01:00:00Z'
          endTime:   '1955-04-01T02:00:00Z'
          duration:  3600000
        }
      }
      expect(now.diff(moment(arg.body.date))).to.be.lessThan 5 * 1000
