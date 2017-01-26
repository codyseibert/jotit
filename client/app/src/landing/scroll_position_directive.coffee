module.exports = [
  '$window'
  ($window) ->
    scope:
      scroll: '=scrollPosition'
    link: (scope, element, attrs) ->
      windowEl = angular.element $window
      handler = ->
        scope.scroll = @pageYOffset
      windowEl.on 'scroll', scope.$apply.bind(scope, handler)
      handler()
]
