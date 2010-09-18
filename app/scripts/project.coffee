Project = {
  options: {
    state: 'normal'
    states: ["normal", "maximized", "minimized"]
  }

  all: []

  _init: ->
    this.all.push this
    @element.bind 'click', =>
      console.debug('clicked', @element)
      @_switchToNextState()
      false

  _switchToNextState: ->
    switch @getState()
      when "normal"
        @maximize()
        @_others (other) ->
          other.minimize()
      when "maximized"
        @_all (project) ->
          project.normalize()
      when "minimized"
        @maximize()
        @_others (other) ->
          other.minimize()
      else console.debug("wrong state", @getState())

  _others: (action) ->
    for project in this.all
      action(project) unless project == this

  _all: (action) ->
    for project in this.all
      action(project)

  getState: ->
    this.options.state

  setState: (newState) ->
    this.options.state = newState

  maximize: ->
    console.debug("maximizing", @element)
    @setState('maximized')

  minimize: ->
    console.debug("minimizing", @element)
    @setState('minimized')

  normalize: ->
    console.debug("normalizing", @element)
    @setState('normal')


}
jQuery.widget 'ui.project', Project

