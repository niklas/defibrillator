class ProjectsController < ApplicationController
  def index
    @title = "Projects"
    @projects = Project.all
  end

  def updates
    @updates = ProjectUpdate.after(params[:after])

#    @updates_ids = ProjectUpdate.all.map(&:id)
#    @updates = ProjectUpdate.where :id => [ @updates_ids[rand(@updates_ids.length)], @updates_ids[rand(@updates_ids.length)]]

    respond_to do |wants|
      wants.js
      wants.json do
        render :json => @updates
      end
    end
  end

end
