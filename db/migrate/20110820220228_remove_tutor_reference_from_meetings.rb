class RemoveTutorReferenceFromMeetings < ActiveRecord::Migration
  def self.up
    remove_column  :meetings, :tutor_id
    remove_column  :meetings, :tutor
  end

  def self.down
    change_table :meetings do |t|
      t.references  :tutor, :class_name => "User"
      t.string      :tutor
    end
  end
end
