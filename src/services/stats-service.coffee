moment  = require 'moment'
UUID    = require 'uuid'
debug   = require('debug')('meshblu-verifier-stats:stats-service')

class MeshbluVerifierStatsService
  constructor: ({ @elasticsearch, @elasticsearchIndex }) ->
    throw new Error 'Missing required parameter: elasticsearch' unless @elasticsearch?
    throw new Error 'Missing required parameter: elasticsearchIndex' unless @elasticsearchIndex?

  create: ({ name, operation, startTime, endTime }, callback) =>
    record = @_buildRecord({ name, operation, startTime, endTime })
    debug {record}

    @elasticsearch.create record, (err) =>
      callback err

  _buildRecord: ({ name, operation, startTime, endTime }) =>
    dateStr = moment().format("YYYY-MM-DD")
    index   = "#{@elasticsearchIndex}:#{dateStr}"

    return {
      id: UUID.v4()
      index: index
      type: name
      body:
        index: index
        type: name
        date: moment().format()
        operation: operation
        startTime: startTime
        endTime: endTime
        duration: moment(endTime).diff(moment(startTime))
    }

  _createError: (message='Internal Service Error', code=500) =>
    error = new Error message
    error.code = code
    return error

module.exports = MeshbluVerifierStatsService
