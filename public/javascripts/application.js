
$(document).ready(function() {
    var updatedAt = $('#metadata .updated_at').text();

    $('#projects').data('updatedAt', $('#projects').attr('updatedAt'));

    var applyBehaviours = function() {
      $('#projects .project').each(function() {
        var $project = $(this);
        var $updates = $project.find('.updates .update');
        $updates.each(function(i) {
          $(this).fadeTo(100, 1.2 - (i / $updates.length  ) );
        });
      });

      $('.progress').each(function() {
        var $elem = $(this);
        $elem.countdown({
          until: $elem.attr('data-seconds-left'),
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
          }
        });
      }
    };
    setInterval( updateProjects, 5000);

    applyBehaviours();

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
        setTimeout( reloadPage, 1000 * 1);
      }
    };
    setTimeout( reloadPage, 1000 * 60 * 15);
});
