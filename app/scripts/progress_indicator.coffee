ProgressIndicator = {
  options: {
    thickness: 5
  }

  _init: ->
    @left  = @element.attr('data-progress-left')
    @total = @element.attr('data-progress-total')

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
            @_drawArc()
          , 300
        })
      .svg('get')

    @graph
      .fadeTo(0, 0.001)
      .css({
        top:   -( @width - @image.height() ) / 2
        right: -( @width - @image.width() ) / 2
      })
      .fadeTo(9000, 0.66)

    $('<div> </div>')
      .addClass('countdown')
      .prependTo(@element)
      .countdown({
        until: @left
        compact: true
        desription: ''
      })


  _drawArc: (fraction) ->
    fraction or= @left/@total
    deg = Math.PI * 2 * fraction
    tx = Math.sin(deg) * (@radius - @thickness) + @radius
    ty = Math.cos(deg) * (@radius - @thickness) + @radius

    path = @svg.createPath()
      .move(@radius, @thickness)
      .arc(@radius - @thickness, @radius - @thickness, 0, true, true, tx, ty)
    @svg.path path, {
        stroke: "#ddd"
        strokeWidth: @thickness
        fill: "none"
      }

}

jQuery.widget 'ui.progress', ProgressIndicator
