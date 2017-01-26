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

      .state 'tos',
        url: '/tos'
        views:
          'main':
            controller: 'TOSCtrl'
            templateUrl: 'tos/tos.html'

      .state 'pp',
        url: '/pp'
        views:
          'main':
            controller: 'PPCtrl'
            templateUrl: 'pp/pp.html'

    return this
]
