module ApplicationHelper

  # url to the cijoe instance of the project
  # these won't be recognized by defribillator, but must be configured in you webserver!
  def cijoe_path(project)
    "/#{project.name}=#{project.revision}"
  end

  def gravatar_tag(author,opts={})
    image_tag author.gravatar_url, opts.merge(:alt => author.name, :class => 'gravatar')
  end

  def anonymous_tag(opts={})
    image_tag 'anonymous.png', :class => 'anonymous gravatar'
  end

  def spinner_tag(opts={})
    image_tag 'building.gif', :class => 'spinner'
  end

  def unknown_tag(opts={})
    image_tag 'new.png', :class => 'new'
  end
end
