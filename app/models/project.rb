class Project < ActiveRecord::Base

  has_many :updates, :class_name => 'ProjectUpdate', :dependent => :destroy
  validates_presence_of :name
  validates_presence_of :revision

  validates_format_of :name,:with => /\A[_\w_]+\z/
  validates_format_of :revision,:with => /\A[_\w_]+\z/

  validates_uniqueness_of :revision, :scope => [:name]

  Stati = %w(new ok failed building).freeze

  validates_inclusion_of :status, :in => Stati

  include Cli::UpdatesFromShell

  # may not change name
  def parse_attributes_from_shell(*)
    new_attr = super
    new_attr.delete('name')
    new_attr.delete('revision')
    new_attr
  end

  def updates_count
    updates.count
  end

  def human_name
    %Q[#{name.humanize.downcase} (#{revision})]
  end

  def name_with_revision
    [name,revision].join('=')
  end

  def self.find_or_create_by_name_with_revision(name_with_revision)
    name, revision = name_with_revision.split('=')
    find_or_create_by_name_and_revision name, revision
  end

  attr_writer :author


  private
  before_update :store_changes
  after_update :persist_stored_changes
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

  before_validation :set_default_status, :on => :create
  def set_default_status
    self.status ||= Stati.first
  end

  before_validation :set_default_revision, :on => :update
  def set_default_revision
    self.revision ||= 'master'
  end

end
