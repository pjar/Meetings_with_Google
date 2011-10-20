class MeetingFieldGoogleSyncStatusToUpToDate < ActiveRecord::Migration
  def self.up
    remove_column :meetings, :google_sync_status
    add_column    :meetings, :up_to_date_with_google, :boolean, :default => false
  end

  def self.down
    remove_column :meetings, :up_to_date_with_google
    add_column    :meetings, :google_sync_status, :string
  end
end
