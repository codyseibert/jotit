module.exports = [
  '$scope'
  '$state'
  '$timeout'
  'UsersService'
  'TokenService'
  'lodash'
  (
    $scope
    $state
    $timeout
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
    $scope.search = ''

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

    $scope.expand = (note) ->
      $scope.expanded = note

    $scope.compress = ->
      $scope.expanded = null

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

    $scope.deleteTopic = (topic) ->
      y = confirm 'are you sure you want to delete this topic?'
      if y is true
        back()
        $scope.current.topics.splice $scope.current.topics.indexOf(topic), 1
        $scope.save()

    $scope.noteFilter = (note) ->
      return true if not $scope.search? or $scope.search is ''
      return note.markdown.indexOf($scope.search) isnt -1

    $scope.addNote = ->
      $scope.current.notes ?= []
      note =
        markdown: ''
        editing: true
        focus: true
      $scope.current.notes.unshift note
      $scope.save()
      $timeout ->
        elm = angular.element(document.querySelectorAll('.focus'))[0]
        elm.focus()
        note.focus = false

    $scope.deleteNote = (note) ->
      y = confirm 'are you sure you want to delete this note?'
      if y is true
        $scope.current.notes.splice $scope.current.notes.indexOf(note), 1
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
