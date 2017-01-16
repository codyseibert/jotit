module.exports = [
  'lodash'
  'localStorageService'
  '$http'
  '$q'
  'TokenService'
  'API_PATH'
  (
    _
    localStorageService
    $http
    $q
    TokenService
    API_PATH
  ) ->

    login: (user) ->
      $http.post "#{API_PATH}/login", user
        .then (response) ->
          token = response.data
          TokenService.setToken token
          token

]
