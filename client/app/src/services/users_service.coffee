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

    show: (userId) ->
      $http.get "#{API_PATH}/users/#{userId}"
        .then (response) ->
          response.data

    put: (user) ->
      $http.put "#{API_PATH}/users/#{user._id}", user
        .then (response) ->
          response.data

]
