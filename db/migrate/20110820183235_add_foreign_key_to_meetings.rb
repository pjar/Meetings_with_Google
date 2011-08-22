class AddForeignKeyToMeetings < ActiveRecord::Migration
  def self.up
    change_table :meetings do |t|
      t.references  :tutor, :class_name => "User"
    end
  end

  def self.down
  end
end
