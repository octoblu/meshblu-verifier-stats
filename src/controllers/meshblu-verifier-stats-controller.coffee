class MeshbluVerifierStatsController
  constructor: ({@meshbluVerifierStatsService}) ->
    throw new Error 'Missing meshbluVerifierStatsService' unless @meshbluVerifierStatsService?

  hello: (request, response) =>
    { hasError } = request.query
    @meshbluVerifierStatsService.doHello { hasError }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(200)

module.exports = MeshbluVerifierStatsController
