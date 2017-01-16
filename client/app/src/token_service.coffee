module.exports = [
  'lodash'
  '$q'
  'localStorageService'
  (
    _
    $q
    localStorageService
  ) ->

    token = localStorageService.get 'token'

    getToken: ->
      token

    setToken: (t) ->
      token = t
      localStorageService.set 'token', t
      if not t?
        localStorageService.remove 'token'

]
