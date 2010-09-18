
$(document).ready(function() {

    $('#projects').data('updatedAt', $('#projects').attr('updatedAt'));

    var applyBehaviours = function() {
      $('#projects .project').each(function() {
        var $project = $(this);
        var $updates = $project.find('.updates .update');
        $updates.each(function(i) {
          $(this).fadeTo(100, 1.2 - (i / $updates.length  ) );
        });
      });

      var drawArc = function(svg, width, thickness, fraction) {
        var radius = width / 2;
        var deg = Math.PI * 2 * fraction;
        var tx = Math.sin(deg) * (radius - thickness) + radius;
        var ty = Math.cos(deg) * (radius - thickness) + radius;
        var path = svg.createPath();
        svg.path( 
          path
            .move(radius, thickness)
            .arc(radius - thickness, radius - thickness, 0, true, true, tx, ty)
            ,
          {stroke: "#ddd", strokeWidth: thickness, fill: "none"}
        );
      };

      $('.progress').each(function() {
        var $elem = $(this);
        var left = $elem.attr('data-progress-left');
        var total = $elem.attr('data-progress-total');
        var $spinner = $elem.find('img.spinner')
          .fadeTo(6000, 0.42);

        var $graphElem = $('<div> </div>')
          .addClass('progress-graph')
          .prependTo($elem);

        var width = $graphElem.width();
        var thickness = 5;

        var $graph = $graphElem.svg({ onLoad: function(svg) {
              drawArc(svg, width, thickness, left/total);
            }
          }).svg('get');

        $graphElem
          .fadeTo(0, 0.001)
          .css({
            'top': -( width - $spinner.height() ) / 2,
            'right': -( width - $spinner.width() ) / 2
          })
          .fadeTo(9000, 0.66);

        $('<div> </div>')
          .addClass('countdown')
          .prependTo($elem)
          .countdown({
            until: left,
            compact: true,
            desription: ''
          });
      });
    };


    var updateProjects = function() {
      var update_path = $('#projects').attr('href');

      if (update_path !== undefined) {
        $.ajax({
          url: update_path + "?after=" + $('#projects').data('updatedAt'),
          dataType: "script",
          complete: function(req, stat) {
            applyBehaviours();
          }
        });
      }
    };
    setInterval( updateProjects, 1000 * $('html').attr('data-refresh-interval'));

    var serverResponsive = false;
    $('body')
      .bind('ajaxSend',  function() {  console.debug('beforeSend'); serverResponsive = false; })
      .bind('ajaxSuccess', function(data, xhr) {  
        if (xhr.status==200) { // success is called even if url not available (DOH), see ~ http://dev.jquery.it/ticket/6060
          console.debug('Success'); 
          serverResponsive = true; 
        }
      });

    // reload whole page every hour, but only if the recent ajax callbacks have
    // verified that the server is responsive (we have bad internet at the
    // office)
    var reloadPage = function() {
      if (serverResponsive) {
        location.reload();
      } else {
        setTimeout( reloadPage, 1000);
      }
    };
    setTimeout( reloadPage, 1000 * $('html').attr('data-reload-interval'));

    var speed = 800;

    $.fn.getState = function() {
      return $(this).data('state') || 'normal';
    };

    $.expr[':'].state = function(node, i, prop, stack) {
      return $node.getState() == state;
    };

    var toHideOnMinimize = ':not(h2.name)';

    $('#projects .project').live('click', function(evt) {

      evt.stopPropagation();

      var $project = $(this).closest('.project'),
          currentState = $project.getState(),
          $statusEl = $project.children('div.status:first'),
          margin = parseInt($project.css('marginTop'), 10),
          indent = $statusEl.width() + 3 * margin,
          $all = $('#projects .project'),
          $others = $all.not($project);

      var byState = function(state) {
        return $all.filter(':state(' + state + ')');
      };

      switch(currentState) {
        case 'normal':
          // TODO save state
          $others
            .animate({left: '-100%', marginRight: '-=' + indent}, speed);

          if ( !$project.children('iframe').length ) {
            $('<iframe>You need iframe support</iframe>')
              .attr('src', $project.find('h2.name a').attr('href'))
              .appendTo($project.children('div.iframe:first'));
          }

          $project
            .animate({marginLeft: '+=' + indent}, speed, function() {
              var p = $project.position();
              $project
                .data('old-position', p)
                .data('old-height', $project.height())
                .data('old-width', $project.width())
                .css({
                  position: 'absolute',
                  top: p.top,
                  left: p.left,
                  width: $project.width()
                })
                .animate({
                  top: 0,
                  bottom: margin + parseInt($project.css('marginBottom'),10),
                  right: margin
                }, speed, function() {
                  $project.css({
                    width: 'auto'
                  })
                  .children('div.iframe')
                    .show('fade', speed)
                  .end()
                });

            });

          newState = 'maximized';
          // code
          break;

        case 'maximized':
          var p = $project.data('old-position'),
              oldHeight = $project.data('old-height'),
              oldWidth = $project.data('old-width');

          $project
            .children('div.iframe')
              .hide('fade', speed)
            .end()
            .animate({top: p.top, left: p.left, height: oldHeight, width: oldWidth}, speed, function() {
                $project.css({
                  position: 'relative',
                  top: 0,
                  left: 0,
                  width: 'auto',
                  bottom: 'auto',
                  right: 'auto',
                  height: 'auto'
                })
                .animate({marginLeft: '-=' + indent}, speed)
            })
          // must give 0%, at 0 chrome shivers
          $others.delay(speed).animate({left: '0%', marginRight: '+=' + indent}, speed);
          newState = 'normal';
          break;
          
        
        default:
          // code
      }
      
      $project.data('state', newState);
      return false;
    });

    applyBehaviours();

});
