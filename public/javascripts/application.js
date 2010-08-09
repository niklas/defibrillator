
$(document).ready(function() {
    var updatedAt = $('#metadata .updated_at').text();
    var updateProjects = function() {
      var update_path = $('#projects').attr('href');

      if (update_path !== undefined) {
      
        $.getJSON(update_path + "?after=" + updatedAt, function(data, stat) {
          $(data).each(function() {

            if (this.project_update) {
              var update = this.project_update;

              var $elem = $('#project_' + update.project_id);

              if (update.status) {
                $elem.removeClass('new ok failed building').addClass(update.status)
                  .find('.status')
                    .text(update.status);
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

    // reload whole page every hour
    setTimeout( function() { location.reload(); }, 1000 * 60 * 60);
});
