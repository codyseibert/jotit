module.exports = [
  '$scope'
  '$state'
  '$timeout'
  '$window'
  'UsersService'
  'TokenService'
  'lodash'
  (
    $scope
    $state
    $timeout
    $window
    UsersService
    TokenService
    _
  ) ->

    if TokenService.getToken()?
      $state.go 'topics'

    $scope.loginWithFacebook = (a) ->
      if a? and a is true
        $window.location.href = "http://notemanapi.seibertsoftwaresolutions.com/login/facebook"

    return this
]
