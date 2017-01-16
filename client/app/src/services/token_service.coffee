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
    user = localStorageService.get 'user'

    getUser: ->
      user

    setUser: (u) ->
      user = u
      localStorageService.set 'user', u
      if not u?
        localStorageService.remove 'user'

    getToken: ->
      token

    setToken: (t) ->
      token = t
      localStorageService.set 'token', t
      if not t?
        localStorageService.remove 'token'

]
