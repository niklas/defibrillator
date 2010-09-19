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
        @normalize()
        @_others (project) ->
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
    @options.state

  setState: (newState) ->
    @options.state = newState

  maximize: ->
    if @is_normal()
      console.debug("normal -> maximized", @element)
    else if @is_minimized()
      console.debug("minimized -> maximized", @element)
    @setState('maximized')

  minimize: ->
    if @is_normal()
      console.debug("normal -> minimized", @element)
    else if @is_maximized()
      console.debug("maximized -> minimized", @element)
    @setState('minimized')

  normalize: ->
    if @is_minimized()
      console.debug("minimized -> normal", @element)
    else if @is_maximized()
      console.debug("maximized -> normal", @element)
    @setState('normal')

  is_maximized: ->
    @getState() == 'maximized'
  is_minimized: ->
    @getState() == 'minimized'
  is_normal: ->
    @getState() == 'normal'


}
jQuery.widget 'ui.project', Project

