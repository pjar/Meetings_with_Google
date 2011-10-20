class AddDeletedColumnForMeetings < ActiveRecord::Migration
  def self.up
    add_column  :meetings, :deleted,  :boolean, :default => false
  end

  def self.down
    remove_column :meetings,  :deleted
  end
end
