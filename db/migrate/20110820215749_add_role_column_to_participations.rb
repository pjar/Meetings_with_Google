class AddRoleColumnToParticipations < ActiveRecord::Migration
  def self.up
    add_column  :participations, :user_as_host, :boolean
  end

  def self.down
    remove_column :participations, :user_as_host, :boolean
  end
end
