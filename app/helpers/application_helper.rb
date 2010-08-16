module ApplicationHelper

  # url to the cijoe instance of the project
  # these won't be recognized by defribillator, but must be configured in you webserver!
  def cijoe_path(project)
    "/#{project.name}=#{project.revision}"
  end
end
