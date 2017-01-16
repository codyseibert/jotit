module.exports = [
  'lodash'
  '$http'
  '$q'
  'API_PATH'
  (
    _
    $http
    $q
    API_PATH
  ) ->

    forgot: (body) ->
      $http.post "#{API_PATH}/password/forgot", body
        .then (response) ->
          response.data

    reset: (resetInfo) ->
      $http.post "#{API_PATH}/password/reset", resetInfo
        .then (response) ->
          response.data

]
