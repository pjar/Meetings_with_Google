# == Schema Information
#
# Table name: meetings
#
#  id                 :integer         not null, primary key
#  starts_at          :datetime
#  ends_at            :datetime
#  title              :string(255)
#  description        :text
#  place              :string(255)
#  tutor              :string(255)
#  total_places       :integer
#  google_event_id    :string(255)
#  google_sync_status :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Meeting < ActiveRecord::Base
  attr_accessible :starts_at, :ends_at, :title, :description,
                  :place, :tutor, :available_places, :total_places,
                  :google_event_id, :google_sync_status
  validate :dates_cannot_collide


##############################################

### UPDATING Meeting

  def update_meeting_attrs(params)
    temp_meeting_attrs = self.attributes
    params = temp_meeting_attrs.merge(params)
    self.destroy
    if Meeting.create(params)
       true
    else
      Meeting.create(temp_meeting_attrs)
      false
    end
  end

### end of UPDATING Meeting

  protected

    # Validations

    # Check if there is no other meeting in that time
    def dates_cannot_collide
      Meeting.all.each do |meeting|
        # does it start within other meeting time?
        if starts_at >= meeting.starts_at && starts_at <= meeting.ends_at
          errors.add(:starts_at,  'There is another meeting at this time')
        # does it end within other meeting time?
        elsif ends_at >= meeting.starts_at && ends_at <= meeting.ends_at
          errors.add(:ends_at,  'There is another meeting at this time')
        # does it run through other meeting time?
        elsif starts_at <= meeting.starts_at && ends_at >= meeting.ends_at
          errors.add(:starts_at, 'There is another meeting within that time')
        end
      end
    end

end



