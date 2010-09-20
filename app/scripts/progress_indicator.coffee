ProgressIndicator = {
  options: {
    thickness: 5
    circle:
      stroke: "#ddd"
      strokeWidth: 5
      fill: "none"
      opacity: 0.8
      id: 'circle'
    background_circle:
      stroke: "#282828"
      strokeWidth: 5
      fill: "none"
      opacity: 0.2
      id: 'background'
    pivot:
      stroke: "#eeeeee"
      strokeWidth: 2
      fill: "#fff"
      opacity: 0.9
      id: 'pivot'
  }

  _init: ->
    @left  = parseInt @element.attr('data-progress-left'), 10
    @total = parseInt @element.attr('data-progress-total'), 10

    @image = @element
      .find('img.spinner')
        .fadeTo(6000, 0.42)

    @options.spinnerHeight = @element.find('img.spinner').height()

    @graph = $('<div> </div>')
      .addClass('progress-graph')
      .prependTo(@element)

    @width = @graph.width()
    @radius = @width / 2
    @thickness = @options.thickness


    @svg = @graph
      .svg({
        onLoad: (svg) =>
          setTimeout =>
            @_initGraph()
            @_updateGraph()
          , 300
        })
      .svg('get')

    @graph
      .fadeTo(0, 0.001)
      .css({
        top:   -( @width - @image.height() ) / 2
        right: -( @width - @image.width() ) / 2
      })
      .fadeTo(9000, 1.0)


    tickInterval = if @total > 720 
                     Math.floor(@total / 360)
                   else
                     2
    @countdown = @element.find('.countdown:first')
      .countdown({
        until: @left
        compact: true
        description: ' remaining'
        alwaysExpire: true
        tickInterval: tickInterval
        onTick: (periods) =>
          [hours, minutes, seconds] = periods[4..7]
          @left = seconds +
            minutes * 60 +
            hours * 60 * 60
          @_updateGraph()
        expiryText: "just a bit.."
        onExpiry: =>
          @left = 0
          @_updateGraph()
          @element.effect 'pulsate',{},'slow', =>
            @countdown
              .countdown('destroy')
              .countdown({
                compact: true
                since: -@total
                until: null
                description: " building"
              })

      })


  _updateGraph: () ->
    fraction = (@total-@left)/@total
    $(@svg.getElementById('circle')).remove()
    $(@svg.getElementById('pivot')).remove()

    if fraction < 0
      return

    if fraction >= 1
      fraction = 1
      @svg.circle(@radius, @radius, @radius - @thickness, @options.circle)
    else
      deg = Math.PI * 2 * fraction
      tx = Math.sin(deg) * (@radius - @thickness) + @radius
      ty = -Math.cos(deg) * (@radius - @thickness) + @radius
      path = @svg.createPath()
        .move(@radius, @thickness)
        .arc(@radius - @thickness, @radius - @thickness, 0, (fraction > 0.5), true, tx, ty)
      @svg.path path, @options.circle
      @svg.circle tx, ty, @thickness/2, @options.pivot

  _initGraph: () ->
    @svg.circle @radius, @radius, @radius - @thickness, @options.background_circle

}

jQuery.widget 'ui.progress', ProgressIndicator
