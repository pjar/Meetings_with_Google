class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.references  :user
      t.references  :meeting
      t.text "comments"
      t.timestamps
    end
    add_index :participations, ['user_id', 'meeting_id']
  end

  def self.down
    drop_table :participations
  end
end
