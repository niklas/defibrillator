class ProjectUpdate < ActiveRecord::Base

  belongs_to :project

  def self.after(time)
    time = Time.parse(time) unless time.is_a?(Time)
    where('updated_at > ?', time + 1.second)
  end

  def self.recent(n=20)
    order('created_at DESC').limit(n)
  end

  def self.results
    where(:status => %w(ok failed))
  end

end
