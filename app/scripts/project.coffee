Project = {
  options: {
    state: 'normal'
    states: ["normal", "maximized", "minimized"]
    speed: 800
  }

  all: []

  _create: ->
    this.all.push this
    @iframe = @element.find('div.iframe:first')

  _init: ->
    @options.margin or= parseInt @element.css('marginTop'), 10
    @options.indent or= @element.find('.status:first').width() + 3 + @options.margin
    @position = @_savePosition()

    @element.css({cursor: 'pointer'}).bind 'click', =>
      @_switchToNextState()
      false

    jQuery(window).bind 'resize', =>
      @_updateIframeHeight()

    @element.find('.health:not(:has(.ok))').each ->
      health = jQuery(this).attr('data-health')
      jQuery('<div> </div>').
        addClass('ok').
        css({width: '100%'}).
        appendTo(this).
        animate({width: health + '%'}, 3000)
      jQuery(this).animate({opacity: 0.7}, 1000)

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
        top: -@position.top
      }, @options.speed
    else if @is_minimized()
      @element.animate {
        left: 0
        marginLeft: '+=' + @options.indent
        marginRight: '+=' + @options.indent
        top: -@position.top
        opacity: 1.0
      }, @options.speed

    @iframe.
      hide().
      delay(@options.speed / 2).
      show('fade', @options.speec / 2)
    @setState('maximized')

  minimize: ->
    if @is_normal()
      @element.animate {
        left: '-100%'
        marginRight: '-=' + @options.indent
        opacity: 0.7
      }, @options.speed
    else if @is_maximized()
      @element.animate {
        top: 0
        left: '-100%'
        marginLeft: '-=' + @options.indent
        marginRight: '-=' + @options.indent
        opacity: 0.7
      }, @options.speed
      @iframe.
        hide('fade', @options.speed / 2)
    @setState('minimized')

  normalize: ->
    if @is_minimized()
      @element.
        animate {
          left: 0
          marginRight: '+=' + @options.indent
          opacity: 1.0
        }, @options.speed
    else if @is_maximized()
      @iframe.
        hide('fade', @options.speed / 2)
      @element.
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
    if !@iframe.find('iframe').length
      $('<iframe>You need iframe support</iframe>').
        attr('src', @element.find('h2.name a').attr('href')).
        appendTo( @iframe )
    else
      @iframe.find('iframe')[0].contentDocument.location.reload(true)
    @_updateIframeHeight()

  _updateIframeHeight: ->
    @iframe.height( $(window).height() - 3 * @position.height )

  _savePosition: ->
    @options.position = @element.position()
    @options.position.height = @element.height()
    @options.position.width  = @element.width()
    @options.position


}
jQuery.widget 'ui.project', Project

