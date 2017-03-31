StatsController = require './controllers/stats-controller'

class Router
  constructor: ({ statsService }) ->
    throw new Error 'Missing statsService' unless statsService?

    @statsController = new StatsController { statsService }

  route: (app) =>

    app.post '/stats/:name', @statsController.create
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
