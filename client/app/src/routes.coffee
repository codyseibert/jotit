module.exports = [
  '$stateProvider'
  '$urlRouterProvider'
  '$locationProvider'
  (
    $stateProvider
    $urlRouterProvider
    $locationProvider
  ) ->
    $urlRouterProvider.otherwise '/'

    $locationProvider.html5Mode enabled: true, requireBase: false
    $locationProvider.hashPrefix '!'

    $stateProvider
      .state 'main',
        url: '/'
        views:
          'main':
            controller: 'LandingCtrl'
            templateUrl: 'landing/landing.html'

      .state 'topics',
        url: '/topics'
        views:
          'main':
            controller: 'MainCtrl'
            templateUrl: 'main/main.html'

      .state 'login',
        url: '/login'
        views:
          'main':
            controller: 'LoginCtrl'
            templateUrl: 'login/login.html'

    return this
]
