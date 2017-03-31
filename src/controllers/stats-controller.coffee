class MeshbluVerifierStatsController
  constructor: ({@statsService}) ->
    throw new Error 'Missing statsService' unless @statsService?

  create: (request, response) =>
    { name } = request.params
    { operation, startTime, endTime } = request.body

    @statsService.create { name, operation, startTime, endTime }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(201)

module.exports = MeshbluVerifierStatsController
