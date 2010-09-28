class Project < ActiveRecord::Base

  extend ActiveSupport::Memoizable

  has_many :updates, :class_name => 'ProjectUpdate', :dependent => :destroy, :inverse_of => :project, :order => 'created_at ASC'
  validates_presence_of :name
  validates_presence_of :revision

  validates_format_of :name,:with => /\A[\w_]+\z/
  validates_format_of :revision,:with => /\A[\w_]+\z/

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

  def remaining_buildtime
    last_buildtime - building_since
  end

  def building_since
    if last_building.present?
      (Time.zone.now - last_building.created_at).to_i
    else
      42
    end
  end

  def last_building
    updates.building.last
  end

  def last_result
    updates.results.last
  end

  def last_buildtime
    if last_result.present? && last_result.previous_building.present?
      (last_result.created_at - last_result.previous_building.created_at).to_i
    else
      5.minutes.to_i
    end
  end

  attr_writer :author

  def health
    (100.0 * updates.ok.count / updates.results.count).to_i
  rescue FloatDomainError
    0
  end

  memoize :health


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
