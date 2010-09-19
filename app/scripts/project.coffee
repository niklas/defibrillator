Project = {
  options: {
    state: 'normal'
    states: ["normal", "maximized", "minimized"]
    speed: 800
  }

  all: []

  _init: ->
    this.all.push this
    @options.margin or= parseInt @element.css('marginTop'), 10
    @options.indent or= @element.find('.status:first').width() + 3 + @options.margin
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
    if @is_normal()
      @element.animate {
        marginLeft: '+=' + @options.indent
      }, @options.speed, =>
        p = @_savePosition()
        @element.css({
          position: 'absolute',
          top: p.top
          left: p.left
          width: p.width
        }).
        animate {
          top: 0,
          bottom: @options.margin + parseInt(@element.css('marginBottom'),10),
          right: @options.margin
        }, @options.speed, =>
          @element.css({
            width: 'auto'
          }).
          children('div.iframe').show('fade', @options.speed)
    else if @is_minimized()
      console.debug("minimized -> maximized", @element)
    @setState('maximized')

  minimize: ->
    if @is_normal()
      console.debug("normal -> minimized", @element)
      @element.animate {
        left: '-100%'
        marginRight: '-=' + @options.indent
        opacity: 0.7
      }, @options.speed
    else if @is_maximized()
      console.debug("maximized -> minimized", @element)
    @setState('minimized')

  normalize: ->
    if @is_minimized()
      console.debug("minimized -> normal", @element)
      @element.
        delay(@options.speed).
        animate {
          left: '0%'
          marginRight: '+=' + @options.indent
          opacity: 1.0
        }, @options.speed
    else if @is_maximized()
      console.debug("maximized -> normal", @element)
      p = @options.position
      @element.
        children('div.iframe').
          hide().
        end().
        animate {
          top: p.top
          left: p.left
          height: p.height
          width: p.width
        }, @options.speed, =>
          @element.css({
            position: 'relative'
            top: 0
            left: 0
            width: 'auto'
            bottom: 'auto'
            right: 'auto'
            height: 'auto'
          }).
          animate {
            marginLeft: '-=' + @options.indent
          }, @options.speed

    @setState('normal')

  is_maximized: ->
    @getState() == 'maximized'
  is_minimized: ->
    @getState() == 'minimized'
  is_normal: ->
    @getState() == 'normal'

  _addIframe: ->
    if !@element.children('iframe').length
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

