class ProjectsController < ApplicationController
  def index
    @title = "Projects"
    @projects = Project.all
  end

end
