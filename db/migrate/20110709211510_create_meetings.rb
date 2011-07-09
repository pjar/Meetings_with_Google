class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :title
      t.text :description
      t.string :place
      t.string :tutor
      t.integer :total_places
      t.string :google_event_id
      t.string :google_sync_status

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
