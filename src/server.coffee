basicAuth      = require 'basic-auth-connect'
enableDestroy  = require 'server-destroy'
octobluExpress = require 'express-octoblu'
Router         = require './router'
StatsService   = require './services/stats-service'

class Server
  constructor: (options) ->
    { elasticsearch, elasticsearchIndex, @logFn, @disableLogging, @port, @username, @password } = options

    throw new Error 'Missing required parameter: elasticsearch' unless elasticsearch?
    throw new Error 'Missing required parameter: elasticsearchIndex' unless elasticsearchIndex?
    throw new Error 'Missing required parameter: username' unless @username?
    throw new Error 'Missing required parameter: password' unless @password?

    @statsService = new StatsService {elasticsearch, elasticsearchIndex}

  address: =>
    @server.address()

  run: (callback) =>
    app = octobluExpress({ @logFn, @disableLogging })
    app.use basicAuth @username, @password

    router = new Router {@statsService}

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: (callback) =>
    @server.destroy callback

module.exports = Server
