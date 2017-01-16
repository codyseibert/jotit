module.exports = [
  'lodash'
  '$q'
  'TokenService'
  (
    _
    $q
    TokenService
  ) ->

    request: (config) ->
      token = TokenService.getToken()
      config.headers['authorization'] = "Bearer #{token}" if token?
      config
]
