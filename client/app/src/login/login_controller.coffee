module.exports = [
  '$scope'
  '$state'
  'SecurityService'
  'TokenService'
  (
    $scope
    $state
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
        TokenService.setUser result.user
        $state.go 'main'

    return this
]
