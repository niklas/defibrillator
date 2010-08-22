
$(document).ready(function() {
    var updatedAt = $('#metadata .updated_at').text();

    $('#projects').data('updatedAt', $('#projects').attr('updatedAt'));

    var updateProjects = function() {
      var update_path = $('#projects').attr('href');

      if (update_path !== undefined) {
      
        $.ajax({
          url: update_path + "?after=" + $('#projects').data('updatedAt'),
          dataType: "script",
          complete: function(req, stat) {
            console.debug(req);
          }
        });

        // TODO put this into the attribute of #projects
        //    if (updatedAt < update.updated_at) {
        //      updatedAt = update.updated_at;
        //    }


      }
    };
    setInterval( updateProjects, 5000);

    // reload whole page every hour
    setTimeout( function() { location.reload(); }, 1000 * 60 * 5);
});
