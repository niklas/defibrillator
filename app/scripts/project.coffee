Project = {
  options: {
    state: 'normal'
    states: ["normal", "maximized", "minimized"]
    speed: 800
  }

  all: []

  _create: ->
    this.all.push this

  _init: ->
    @options.margin or= parseInt @element.css('marginTop'), 10
    @options.indent or= @element.find('.status:first').width() + 3 + @options.margin
    @position = @_savePosition()
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
    @_addIframe()
    p = @options.position
    if @is_normal()
      @element.animate {
        marginLeft: '+=' + @options.indent
        top: -p.top
      }, @options.speed
    else if @is_minimized()
      @element.animate {
        left: 0
        marginLeft: '+=' + @options.indent
        marginRight: '+=' + @options.indent
        top: -p.top
        opacity: 1.0
      }, @options.speed
    @element.
      children('div.iframe').
        delay(@options.speed).
        show('fade', @options.speed)
    @setState('maximized')

  minimize: ->
    if @is_normal()
      @element.animate {
        left: '-100%'
        marginRight: '-=' + @options.indent
        opacity: 0.7
      }, @options.speed
    else if @is_maximized()
      console.debug("maximized -> minimized", @element)
      @element.animate {
        top: 0
        left: '-100%'
        marginLeft: '-=' + @options.indent
        marginRight: '-=' + @options.indent
        opacity: 0.7
      }, @options.speed
    @setState('minimized')

  normalize: ->
    p = @options.position
    if @is_minimized()
      @element.
        animate {
          left: 0
          marginRight: '+=' + @options.indent
          opacity: 1.0
        }, @options.speed
    else if @is_maximized()
      console.debug("maximized -> normal", @element)
      p = @options.position
      @element.
        children('div.iframe').hide().end().
        animate {
          marginLeft: '-=' + @options.indent
          top: 0
        }, @options.speed

    @setState('normal')

  is_maximized: ->
    @getState() == 'maximized'
  is_minimized: ->
    @getState() == 'minimized'
  is_normal: ->
    @getState() == 'normal'

  _addIframe: ->
    if !@element.find('iframe').length
      $('<iframe>You need iframe support</iframe>')
        .attr('src', @element.find('h2.name a').attr('href'))
        .appendTo( @element.children('div.iframe:first') )

  _savePosition: ->
    @options.position = @element.position()
    @options.position.height = @element.height()
    @options.position.width  = @element.width()
    @options.position


}
jQuery.widget 'ui.project', Project

