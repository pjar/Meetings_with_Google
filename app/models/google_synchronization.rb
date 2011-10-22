# == Schema Information
#
# Table name: google_synchronizations
#
#  id             :integer         not null, primary key
#  object_id      :integer
#  attribute_name :string(255)
#  old_value      :text
#  new_value      :text
#  deleted        :boolean         default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#


class GoogleSynchronization

  include ActiveSupport::Rescuable



  def initialize
    @service = GCal4Ruby::Service.new
  end


  def create_event(meeting)
    event = GCal4Ruby::Event.new(@service)
    event.calendar    = calendar
    event.start_time  = meeting.starts_at.to_s
    event.end_time    = meeting.ends_at.to_s
    event.title       = meeting.title
    event.where       = meeting.place
    event.content     = meeting.description_for_google_calendar
    event.attendees   = meeting.attendees_hash(true)
    if event.save
      meeting.update_attributes(:google_event_id => event.id)
      true
    else
      false
    end
  end

  def delete_event(meeting)
    event = GCal4Ruby::Event.find(@service, :id => meeting.google_event_id)
     if event.status != :canceled
      event.delete
      true
      elsif event.status == :canceled
      meeting.destroy
      true
    end

  end

  def update_event(meeting)
    event = GCal4Ruby::Event.find(@service, :id => meeting.google_event_id)
    event.delete
    create_event(meeting)
  end



  def update_google_cal
     authenticate
     Meeting.all_needing_update.each do |meeting|
       if meeting.google_event_id.nil?
          create_event(meeting)
          true
        elsif meeting.deleted
          delete_event(meeting)
          true
        elsif !meeting.up_to_date_with_google
          update_event(meeting)
          true
        end
      end
  rescue Exception => e
    false
  end

  def authenticate
    @service.authenticate( GOOGLE_ACCOUNT, GOOGLE_ACCOUNT_PASSWORD )
  end

  def calendar
   @service.calendars.first
  end
  def download
    if authenticate
      return true
    end
    false
  end

  def feed
    array = calendar.events.inject([]) do |result, element|
      hash = {}
      hash[:start_at]     = element.start_time
      hash[:ends_at]      = element.end_time
      hash[:title]        = element.title
      hash[:description]  = element.content
      hash[:place]        = element.where
      hash[:total_places] = 0
      hash[:tutor]        = nil
      result << hash
    end
  end
end

