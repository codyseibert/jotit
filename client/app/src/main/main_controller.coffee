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

    $scope.user = null
    $scope.current = null
    $scope.editingNote = false
    $scope.bread = []

    if not TokenService.getToken()?
      $state.go 'login'
      return

    $scope.noteToAdd =
      title: ''
      description: ''

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

    $scope.goto = (note) ->
      while $scope.current isnt note
        back()

    $scope.save = ->
      toPut = _.cloneDeep $scope.user
      clean toPut
      UsersService.put toPut

    $scope.addNote = ->
      $scope.current.notes ?= []
      $scope.current.notes.push $scope.noteToAdd
      $scope.noteToAdd =
        title: ''
        description: ''
      $scope.save()

    $scope.openNote = (note) ->
      note.parent = $scope.current
      $scope.current = note
      $scope.bread.push note

    back = ->
      $scope.current = $scope.current.parent
      $scope.bread.splice $scope.bread.length - 1, 1

    return this
]
