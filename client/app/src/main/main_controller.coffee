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

    $scope.noteToAdd =
      title: ''

    $scope.note = null
    userId = TokenService.getUser()._id

    clean = (node) ->
      delete node.parent
      if node.notes?
        _.each node.notes, clean

    UsersService.show userId
      .then (u) ->
        $scope.user = u
        $scope.current = u
        $scope.current.parent = null

    $scope.getColor = (index) ->
      colors[index % colors.length]

    $scope.goto = (note) ->
      while $scope.current isnt note
        back()

    $scope.save = ->
      $scope.editingNote = false
      toPut = _.cloneDeep $scope.user
      clean toPut
      UsersService.put toPut

    $scope.addNote = ->
      $scope.current.notes ?= []
      $scope.noteToAdd.title = 'untitled'
      $scope.current.notes.push $scope.noteToAdd
      $scope.noteToAdd =
        title: ''
      $scope.save()

    $scope.openNote = (note) ->
      note.parent = $scope.current
      $scope.current = note
      $scope.bread.push note

    $scope.logout = ->
      TokenService.setToken null
      TokenService.setUser null
      $state.go 'login'

    back = ->
      $scope.current = $scope.current.parent
      $scope.bread.splice $scope.bread.length - 1, 1

    return this
]
