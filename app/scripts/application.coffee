jQuery(document).ready ->
  $('#projects .project')
    .project()

  applyBehaviours = ->

    # Fade update fin tails
    $('#projects .project').each ->
      $project = $(this)
      $container = $project.find('.updates')
      $updates = $container.find('.update')
      width = $container.width()
      $updates.each (i) ->
        top = $(this).position().top
        left = $(this).position().left
        opa = if top < 2
                1.2 - left / width
              else
                0.2
        $(this).fadeTo 100, opa

    $('#projects .project .progress:not(:has(.progress-graph.hasSVG))').progress()


  $('#projects').data('updatedAt', $('#projects').attr('updatedAt'))
  updateProjects = ->
    update_path = $('#projects').attr('href')
    if update_path?
      $.ajax({
        url: update_path + "?after=" + $('#projects').data('updatedAt')
        dataType: "script"
        complete: (req, stat) ->
          applyBehaviours()
      })

  setInterval  updateProjects, 1000 * $('html').attr('data-refresh-interval')


  serverResponsive = false
  $('body')
    .bind 'ajaxSend',  ->
      serverResponsive = false
    .bind 'ajaxSuccess', (data, xhr) ->
      # success is called even if url not available (DOH), see ~ http://dev.jquery.it/ticket/6060
      if xhr.status == 200
        serverResponsive = true


  # reload whole page every hour, but only if the recent ajax callbacks have
  # verified that the server is responsive (we have bad internet at the
  # office)

  reloadPage = ->
    if serverResponsive
      location.reload()
    else
      setTimeout reloadPage, 1000
  setTimeout reloadPage, 1000 * $('html').attr('data-reload-interval')

  applyBehaviours()
