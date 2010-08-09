
$(document).ready(function() {
    var updatedAt = $('#metadata .updated_at').text();
    var updateProjects = function() {
      var update_path = $('#projects').attr('href');

      if (update_path !== undefined) {
      
        $.getJSON(update_path + "?after=" + updatedAt, function(data, stat) {
          $(data).each(function() {

            if (this.project_update) {
              var update = this.project_update;

              if (update.status) {
                $('#project_' + update.project_id).find('.status').text(update.status);
              }

              if (updatedAt < update.updated_at) {
                updatedAt = update.updated_at;
              }

            }

          });
        });

      }
    };
    setInterval( updateProjects, 5000);
});
