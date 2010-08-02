class Project < ActiveRecord::Base

  has_many :updates, :class_name => 'ProjectUpdate'
  validates_presence_of :name

  validates_format_of :name,:with => /\A[_\w_]+\z/

  include Cli::UpdatesFromShell

  # may not change name
  def parse_attributes_from_shell(*)
    new_attr = super
    new_attr.delete('name')
    new_attr
  end

  def updates_count
    updates.count
  end

  attr_writer :author

  before_update :store_changes
  after_update :persist_stored_changes

  private
  def store_changes
    @updated_attributes = changes.inject({}) do |upd,change|
      upd[change.first] = change.last.last
      upd
    end
  end

  def persist_stored_changes
    unless @updated_attributes.empty?
      @updated_attributes['author'] = @author
      logger.debug { "updating: #{@updated_attributes.inspect}" }
      updates.create! @updated_attributes
    end
    true
  end

end
