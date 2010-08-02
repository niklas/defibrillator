class ProjectUpdate < ActiveRecord::Base

  belongs_to :project

  def self.after(time)
    time = Time.parse(time) unless time.is_a?(Time)
    where('updated_at > ?', time)
  end

end
