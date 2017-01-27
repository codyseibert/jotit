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
      '#E57C6C'
      '#495872'
      '#4174A6'
      '#99CFE0'
      '#D6E5D8'
      '#CAD8E7'
      '#95A5C3'
      '#91677E'
      '#E65D6E'
      '#FE9E95'
      '#FEDAB3'
      '#EBC9D9'
    ]

    $scope.share = (note) ->
      FB.api "/me/feed",
        "POST",
        "message": note.markdown,
        (response) ->

    $scope.showRequestModal = false
    $scope.request = {}

    $scope.saveRequest = ->
      $scope.user.requests ?= []
      $scope.user.requests.push $scope.request
      $scope.save()
      $scope.request = {}
      $scope.showRequestModal = false

    $scope.alertEventOnClick = (event) ->
      $scope.expanded = event.note

    $scope.uiConfig =
      calendar:
        eventClick: $scope.alertEventOnClick

    events = []

    $scope.tagKeys = []
    $scope.tags = {}

    $scope.eventSources = [
      events: events
    ]

    $scope.showPanel = 'notes'

    $scope.chartKeys = []
    $scope.labels = {}
    $scope.series = ['']
    $scope.data = {}

    charts = []
    $scope.$on 'create', (event, newValue) ->
      if charts.indexOf(newValue) is -1
        charts.push newValue

    getPoints = (node) ->
      points = {}
      if node.notes?
        for e in node.notes
          continue if not e?
          re = /([a-zA-Z0-9]+)\(([0-9]+)\)/
          dateRe = /[0-9]+\/[0-9]+\/[0-9]+/
          result = re.exec e.markdown
          dateResult = dateRe.exec e.markdown
          if result? and dateResult?
            name = result[1]
            points[name] ?= []
            points[name].push
              count: parseInt result[2]
              start: dateResult[0]

      if node.topics?
        _.each node.topics, (t) ->
          ex = getPoints t
          for k, v of ex
            points[k] ?= []
            for n in v
              points[k].push n
      points

    reloadCharts = ->
      pts = getPoints $scope.current

      $scope.chartKeys = Object.keys pts
      for name in $scope.chartKeys
        $scope.data[name] = [
          pts[name].sort (a, b) ->
            moment(a.start).isAfter(moment(b.start))
          .map (x) ->
            x.count
        ]

        $scope.labels[name] = pts[name].sort (a, b) ->
          moment(a.start).isAfter(moment(b.start))
        .map (x) ->
          x.start

      $timeout ->
        for chart in charts
          chart.resize()
          window.dispatchEvent new Event('resize')

    $scope.$watch 'search', (newValue, oldValue) ->
      if $scope.current?
        # TODO: Only do it if we are displaying that panel
        reloadCharts()
        refreshEvents()
        refreshTags()

    $scope.user = null
    $scope.current = null
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

    getEvents = (node) ->
      evts = []
      if node.notes?
        for e in node.notes
          continue if not e?
          if $scope.search isnt ''
            continue if e.markdown.indexOf($scope.search) is -1
          re = /[0-9]+\/[0-9]+\/[0-9]+/
          result = re.exec e.markdown
          if result?
            evts.push
              title: e.markdown.substring 0, 16
              start: result[0]#.replace /\//g, '-'
              note: e
      if node.topics?
        _.each node.topics, (t) ->
          ex = getEvents t
          for e in ex
            evts.push e
      evts

    refreshEvents = ->
      evts = getEvents $scope.current
      events.splice 0, events.length
      for e in evts
        events.push e

    getTags = (node) ->
      tags = {}

      if node.notes?
        for note in node.notes
          continue if not note?
          if $scope.search isnt ''
            continue if note.markdown.indexOf($scope.search) is -1
          re = /#[0-9a-zA-Z]+/g
          while (result = re.exec(note.markdown))
            tag = result[0]
            tags[tag] ?= []
            tags[tag].push note

      if node.topics?
        _.each node.topics, (t) ->
          ex = getTags t
          for k, v of ex
            tags[k] ?= []
            for n in v
              tags[k].push n

      tags

    $scope.getNotes = (node) ->
      notes = []

      if node?.notes?
        for note in node.notes
          continue if not note?
          notes.push note

      if node?.topics?
        _.each node.topics, (t) ->
          ex = $scope.getNotes t
          for n in ex
            notes.push n

      notes

    refreshTags = ->
      tags = getTags $scope.current
      $scope.tagKeys = Object.keys tags
      $scope.tags = {}
      for k, v of tags
        $scope.tags[k] = v

    UsersService.show userId
      .then (u) ->
        $scope.user = u
        $scope.user.data ?= {
          notes: []
          topics: []
        }
        $scope.current = u.data
        $scope.current.parent = null
        refreshEvents()
        refreshTags()
        reloadCharts()

    $scope.reloadCharts = reloadCharts

    $scope.getColor = (index) ->
      colors[index % colors.length]

    $scope.refreshCharts = ->
      $timeout ->
        window.dispatchEvent new Event('resize')

    $scope.goto = (topic) ->
      while $scope.current isnt topic
        back()

    $scope.expand = (note) ->
      $scope.expanded = note

    $scope.compress = ->
      $scope.expanded = null

    $scope.save = ->
      toPut = _.cloneDeep $scope.user
      clean toPut.data
      UsersService.put toPut
      refreshEvents()
      refreshTags()
      reloadCharts()

    $scope.getNoteOrder = (note) ->
      note.favorite isnt true

    $scope.toggleFavorite = (note) ->
      note.favorite = not note.favorite
      $scope.save()

    $scope.addTopic = ->
      $scope.current.topics ?= []
      topic =
        title: ''
        editing: true
        focus: true
      $scope.current.topics.push topic
      $timeout ->
        elm = angular.element(document.querySelectorAll('.topic.focus'))[0]
        elm.focus()
        topic.focus = false
      $scope.save()

    $scope.deleteTopic = (topic) ->
      y = confirm 'are you sure you want to delete this topic?'
      if y is true
        $scope.current.topics.splice $scope.current.topics.indexOf(topic), 1
        $scope.save()

    $scope.noteFilter = (note) ->
      return true if not $scope.search? or $scope.search is ''
      return note.markdown.indexOf($scope.search) isnt -1

    $scope.addNote = ->
      $scope.showPanel = 'notes'
      $scope.current.notes ?= []
      note =
        markdown: ''
        editing: true
        focus: true
      $scope.current.notes.unshift note
      $scope.save()
      $timeout ->
        $('.focus').focus()
        $(window).scrollTop $('.focus').position().top
        note.focus = false

    deleteNote = (node, note) ->
      if node?.notes?
        if node.notes.indexOf(note) isnt -1
          node.notes.splice node.notes.indexOf(note), 1

      if node?.topics?
        _.each node.topics, (t) ->
          deleteNote t, note

    $scope.deleteNote = (note) ->
      y = confirm 'are you sure you want to delete this note?'
      if y is true
        deleteNote $scope.current, note
        $scope.save()

    $scope.openTopic = (topic) ->
      topic.hovered = false
      topic.parent = $scope.current
      $scope.current = topic
      $scope.bread.push topic
      refreshEvents()
      refreshTags()
      reloadCharts()

    $scope.logout = ->
      TokenService.setToken null
      $state.go 'main'

    $scope.renderCalendar = (calendarId) ->
      $timeout ->
        calendarTag = $ '.calendar'
        calendarTag.fullCalendar 'render'
        refreshEvents()

    back = ->
      $scope.current = $scope.current.parent
      $scope.bread.splice $scope.bread.length - 1, 1
      refreshEvents()
      refreshTags()
      reloadCharts()

    return this
]
