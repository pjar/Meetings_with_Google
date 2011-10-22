class CreateUserNotes < ActiveRecord::Migration
  def self.up
    create_table :user_notes do |t|
        t.references  :participation
        t.text  :note
      t.timestamps
    end
  end

  def self.down
    drop_table :user_notes
  end
end
