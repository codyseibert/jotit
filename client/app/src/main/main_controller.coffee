module.exports = [
  '$scope'
  '$state'
  'UsersService'
  'TokenService'
  'lodash'
  (
    $scope
    $state
    UsersService
    TokenService
    _
  ) ->

    colors = [
      '#ff72a0'
      '#565fc8'
      '#ff9000'
      '#78cb0b'
      '#1aacf7'
      '#00c5c6'
    ]

    $scope.user = null
    $scope.current = null
    $scope.editingNote = false
    $scope.bread = []

    if not TokenService.getToken()?
      $state.go 'login'
      return

    $scope.note = null
    userId = TokenService.getUser()._id

    $scope.count = (topic) ->
      sum = 0
      if topic.notes?
        sum += topic.notes.length
      if topic.topics?
        for t in topic.topics
          sum += $scope.count t
      sum

    clean = (node) ->
      delete node.parent
      if node.topics?
        _.each node.topics, clean

    UsersService.show userId
      .then (u) ->
        $scope.user = u
        $scope.user.data ?= {
          notes: []
          topics: []
        }
        $scope.current = u.data
        $scope.current.parent = null

    $scope.getColor = (index) ->
      colors[index % colors.length]

    $scope.goto = (topic) ->
      while $scope.current isnt topic
        back()

    $scope.save = ->
      $scope.editingNote = false
      toPut = _.cloneDeep $scope.user
      clean toPut.data
      UsersService.put toPut

    $scope.addTopic = ->
      $scope.current.topics ?= []
      $scope.current.topics.push
        title: 'untitled'
        editing: true
      $scope.save()

    $scope.addNote = ->
      $scope.current.notes ?= []
      $scope.current.notes.push
        markdown: 'Click to Write Note'
      $scope.save()

    $scope.openTopic = (topic) ->
      topic.hovered = false
      topic.parent = $scope.current
      $scope.current = topic
      $scope.bread.push topic

    $scope.logout = ->
      TokenService.setToken null
      TokenService.setUser null
      $state.go 'login'

    back = ->
      $scope.current = $scope.current.parent
      $scope.bread.splice $scope.bread.length - 1, 1

    return this
]
