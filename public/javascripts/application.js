
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

    // reload whole page every hour
    setTimeout( function() { location.reload(); }, 1000 * 60 * 5);
});
