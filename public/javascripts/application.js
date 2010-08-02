
$(document).ready(function() {
    var updatedAt = $('#metadata .updated_at').text();
    var updateProjects = function() {
      $.getJSON("updates.js?after=" + updatedAt, function(data, stat) {
        $(data).each(function() {

          if (this.project_update) {
            var update = this.project_update;
            console.debug(update);

            if (update.status) {
              $('#project_' + update.project_id).find('.status').text(update.status);
            }

            if (updatedAt < update.updated_at) {
              updatedAt = update.updated_at;
            }

          }

        });
      });
    };
    setInterval( updateProjects, 5000);
});
