class AddRevisionToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :revision, :string
  end

  def self.down
    remove_column :projects, :revision
  end
end
