envalid        = require 'envalid'
elasticsearch  = require 'elasticsearch'
SigtermHandler = require 'sigterm-handler'
Server         = require './src/server'

envConfig = {
  PORT: envalid.num({ default: 80, devDefault: 3000 })
  ELASTICSEARCH_INDEX: envalid.str()
  ELASTICSEARCH_URI: envalid.url()
  HTTP_USERNAME: envalid.str()
  HTTP_PASSWORD: envalid.str()
}

class Command
  constructor: ->
    env = envalid.cleanEnv process.env, envConfig
    @serverOptions = {
      port          : env.PORT
      elasticsearch:      elasticsearch.Client host: env.ELASTICSEARCH_URI
      elasticsearchIndex: env.ELASTICSEARCH_INDEX
      username: env.HTTP_USERNAME
      password: env.HTTP_PASSWORD
    }

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    server = new Server @serverOptions
    server.run (error) =>
      return @panic error if error?

      { port } = server.address()
      console.log "MeshbluVerifierStatsService listening on port: #{port}"

    sigtermHandler = new SigtermHandler()
    sigtermHandler.register server.stop

command = new Command()
command.run()
