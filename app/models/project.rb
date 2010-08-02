class Project < ActiveRecord::Base

  has_many :updates, :class_name => 'ProjectUpdate'
  validates_presence_of :name

  validates_format_of :name,:with => /\A[_\w_]+\z/

  def update_attributes_from_shell(argv)
    new_attr = argv.inject({}) do |hash, arg|
      key, val = arg.split(':')
      if key && val
        hash[key] = val
      end
      hash
    end
    update_attributes new_attr
  end

end
