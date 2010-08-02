class Project < ActiveRecord::Base

  has_many :updates, :class_name => 'ProjectUpdate'
  validates_presence_of :name

end
