module.exports = [
  'lodash'
  '$q'
  'localStorageService'
  'jwtHelper'
  (
    _
    $q
    localStorageService
    jwtHelper
  ) ->

    token = localStorageService.get 'token'

    getUser: ->
      jwtHelper.decodeToken token

    getToken: ->
      token

    setToken: (t) ->
      token = t
      localStorageService.set 'token', t
      if not t?
        localStorageService.remove 'token'

]
