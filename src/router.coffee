MeshbluVerifierStatsController = require './controllers/meshblu-verifier-stats-controller'

class Router
  constructor: ({ @meshbluVerifierStatsService }) ->
    throw new Error 'Missing meshbluVerifierStatsService' unless @meshbluVerifierStatsService?

  route: (app) =>
    meshbluVerifierStatsController = new MeshbluVerifierStatsController { @meshbluVerifierStatsService }

    app.get '/hello', meshbluVerifierStatsController.hello
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
