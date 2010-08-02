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

  def updates_count
    updates.count
  end

  before_update :store_changes
  after_update :persist_stored_changes

  private
  def store_changes
    @update_attributes = changes.inject({}) do |upd,change|
      upd[change.first] = change.last.last
      upd
    end
  end

  def persist_stored_changes
    logger.debug { "updating: #{@update_attributes.inject}" }
    updates.create! @update_attributes
  end

end
