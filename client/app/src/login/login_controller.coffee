module.exports = [
  '$scope'
  '$state'
  '$window'
  'SecurityService'
  'TokenService'
  (
    $scope
    $state
    $window
    SecurityService
    TokenService
  ) ->

    $scope.email = ''
    $scope.password = ''

    $scope.login = ->
      SecurityService.login
        email: $scope.email
        password: $scope.password
      .then (result) ->
        TokenService.setToken result.token
        $state.go 'main'

    $scope.loginWithFacebook = ->
      $window.location.href = "http://jotitapi.seibertsoftwaresolutions.com/login/facebook"

    return this
]
