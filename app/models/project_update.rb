class ProjectUpdate < ActiveRecord::Base

  belongs_to :project

  composed_of :author_person, :mapping => [ %w(author line) ], :class_name => 'Author'

  def has_author?
    author.present? && author_person.present?
  end

  def self.after(time)
    time = Time.parse(time) unless time.is_a?(Time)
    where('created_at > ?', time + 1.second)
  end

  def self.before(time)
    time = Time.parse(time) unless time.is_a?(Time)
    where('created_at < ?', time - 1.second)
  end

  def self.recent(n=66)
    order('created_at DESC').limit(n)
  end

  def self.ok
    where(:status => "ok")
  end

  def self.results
    where(:status => %w(ok failed))
  end

  def self.building
    where(:status => 'building')
  end

  def previous_building
    previous.building.last
  end

  def previous
    project.updates.before(created_at).order('created_at ASC')
  end

end
