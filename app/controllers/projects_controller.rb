class ProjectsController < ApplicationController
  def index
    @title = "Projects"
    @projects = Project.all
  end

  def updates
    @updates = ProjectUpdate.after(params[:after])

    render :json => @updates
  end

end
