class CreateProjectUpdates < ActiveRecord::Migration
  def self.up
    create_table :project_updates do |t|
      t.integer :project_id
      t.string :author
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :project_updates
  end
end
