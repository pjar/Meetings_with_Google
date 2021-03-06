
# == Schema Information
#
# Table name: meetings
#
#  id                     :integer         not null, primary key
#  starts_at              :datetime
#  ends_at                :datetime
#  title                  :string(255)
#  description            :text
#  place                  :string(255)
#  total_places           :integer
#  google_event_id        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  up_to_date_with_google :boolean         default(FALSE)
#  deleted                :boolean         default(FALSE)
#



class Meeting < ActiveRecord::Base

  # it allows tracking changes in model objects - see declaration of validations
  include ActiveModel::Dirty



  has_many    :participations, :dependent => :destroy
  has_many    :users, :through => :participations

  attr_accessible   :starts_at, :ends_at, :title, :description,
                  :place, :tutor, :available_places, :total_places,
                  :google_event_id, :up_to_date_with_google, :deleted,
                  :start_time, :end_time, :meeting_date

  #attr_accessible :start_time, :end_time, :meeting_date

  scope :all_active, where(:deleted => false)

  scope :deleted, where( :deleted => true )

  scope :outdated, where( :up_to_date_with_google => false )

  scope :all_needing_update, where("deleted = ? OR up_to_date_with_google = ?", true, false)

  scope :ordered, order("starts_at ASC")

  scope :by_month, lambda { |date| { :conditions => { :starts_at => date.beginning_of_month..date.end_of_month} } }

  validate  :dates_cannot_collide
  validate  :cannot_end_before_start


##############################################

### CREATING Meeting

  ## uses a method to construct proper params - it's due ugly datetime select in new_meeting form
  def self.new_meeting( params )
    params = ends_at_param_builder( params )
    Meeting.new( params )
  end

  def save_with_sync
    if self.save
      update_status_and_sync( :up_to_date_with_google => false )
      true
    else
      false
    end
  end

### end of CREATING Meeting

##############################################


##############################################

### READING Meeting

  def self.find_meeting( params )
    @meeting ||= Meeting.find( params )
  end

### end of READING Meeting


##############################################

### UPDATING Meeting

  ## uses a method to construct proper params - it's due ugly datetime select in update_meeting form

  def update_status_and_sync( status )
    update_attributes( status )
    sync = GoogleSynchronization.new
    if sync.update_google_cal
      update_attributes( :up_to_date_with_google => true )
      true
    else
      false
    end

  end

  def update_attributes_with_sync( params )
    params = ends_at_param_builder( params )
    if update_attributes( params )
      update_status_and_sync( :up_to_date_with_google => false )
      true
    else
      false
    end
  end

### end of UPDATING Meeting

##############################################

### DESTROYING Meeting

  def destroy_and_sync
    if update_status_and_sync(:deleted => true)
      self.destroy
      true
    else
     false
    end
  end

### end of DESTROYING Meeting

#### Date formatting

  def meeting_date( part = nil )
    if part
      starts_at.send( :strftime, "#{part}" )
    else
      starts_at.strftime("%d %b") unless starts_at.nil?
    end
  end

  def meeting_date=(date)
    date
  end

  def start_time
    starts_at.to_s(:time) unless starts_at.nil?
  end

  def start_time=(time)
    time
  end

  def end_time
    ends_at.to_s(:time)   unless ends_at.nil?
  end

  def end_time=(time)
    time
  end

#  def duration
#    distance_of_time_in_words(self.starts_at, self.ends_at)
#  end

#### end of Date formatting

  def has_free_places?
    available_places > 0 ? true : false
  end

  def has_no_host?
    !self.host_present?
  end

  def available_places
    total_places - participations.without_host.size
  end

  def host
    if host_present?
      participations.each do |p|
        if p.user_as_host
          return p.user
        end
      end
    end
  end

  def attendees(with_host = false)
    attendees = []
    attenders = with_host ? participations : if participations.empty?
                                                participations
                                             else
                                                participations.without_host
                                             end
    attenders.collect { |p| attendees << p.user }
    attendees
  end


  def attendees_hash(with_host = false)
    if attendees(with_host).empty?
      return []
    end
    attendees(with_host).inject([]) do |result,element|
      hash = {}
      hash[:name] = element.name
      hash[:email] = element.email
      result << hash
    end
  end


  def description_for_google_calendar
    description_content = self.description.dup
    description_content += "\n"
    if host.present?
      description_content += "\nTutor: #{host.email}"
    end
    description_content += "\nMeeting ID: #{id}"
  end


protected

  # building ends_at date from date only component of starts_at and time only component of ends_at
  # it's used to simplify meeting creation form

  #



  def host_present?
      participations.each do |p|
        if p.user_as_host
          return true
        end
      end
    false
  end

  # I know it's ridiculous to have 2 same methods
  # Any way to have same method for class and object?
  def self.ends_at_param_builder(params)
    start_date = params[:meeting_date] + " " + params[:start_time]
    if params[:start_time] > params[:end_time]
      meeting_end_date = (Date.parse( params[:meeting_date] ) + 1.day ).to_s
      end_date =  meeting_end_date + " " + params[:end_time]
    else
      end_date =  params[:meeting_date] + " " + params[:end_time]
    end

    params[:starts_at] = Time.parse( start_date )
    params[:ends_at]  = Time.parse( end_date )
    params
  end

  def ends_at_param_builder(params)
    start_date = params[:meeting_date] + " " + params[:start_time]

    if params[:start_time] > params[:end_time]
      meeting_end_date = (Date.parse( params[:meeting_date] ) + 1.day ).to_s
      end_date =  meeting_end_date + " " + params[:end_time]
    else
      end_date =  params[:meeting_date] + " " + params[:end_time]
    end

    params[:starts_at] = Time.parse( start_date )
    params[:ends_at]  = Time.parse( end_date )
    params
  end

  def self.places
    places = []
    Meeting.all_active.collect {|m| places << m.place}
    places
  end

  def self.places_sorted_by_times_used

    hash = Meeting.places.inject({}) do | result, array_value |
	    key_from_array_value = array_value.downcase.gsub(/\s+/, "_").to_sym
	    if result.has_key?( key_from_array_value )
	      result[ key_from_array_value ] += 1
	    else
	      result[ key_from_array_value ] = 1
	    end
	  result
    end

    hash = hash.sort_by { |element| element.last }

    array = hash.reverse.inject([]) do |result,hash_element|
      result << hash_element.first.to_s.capitalize
    end



  end


  def not_comparing_same_meetings?(meeting)
    !id.eql?(meeting.id)
  end

  def comparing_meetings_with_same_venue?(meeting)
    place.eql?(meeting.place)
  end

  def meeting_starts_within_other?(meeting)
    starts_at >= meeting.starts_at && starts_at <= meeting.ends_at
  end

  def meeting_ends_within_other?(meeting)
    ends_at >= meeting.starts_at && ends_at <= meeting.ends_at
  end

  def meeting_runs_through_other?(meeting)
    starts_at <= meeting.starts_at && ends_at >= meeting.ends_at
  end

  def produce_meeting_date_collision_error(meeting, symbol)
    errors.add(symbol,  ' - There is another meeting between ' +
                         meeting.starts_at.strftime("%R") +
                                           meeting.ends_at.strftime("-%R"))
  end

### Validations

  # Check if there is no other meeting in that time
  def dates_cannot_collide
   # let's check if date or place has changed - if not then dont bother with validatiot
    if starts_at_changed? || ends_at_changed? || place_changed?
      Meeting.all_active.each do |meeting|
        if not_comparing_same_meetings?(meeting)
          if comparing_meetings_with_same_venue?(meeting)
            # does it start within other meeting time?
            # TODO: DRY it out
            if meeting_starts_within_other?(meeting)
              produce_meeting_date_collision_error(meeting, :starts_at)
            # does it end within other meeting time?
            elsif meeting_ends_within_other?(meeting)
              produce_meeting_date_collision_error(meeting, :ends_at)
            # does it run through other meeting time?
            elsif meeting_runs_through_other?(meeting)
              produce_meeting_date_collision_error(meeting, :starts_at)
            end
          end
        end
      end
    end
  end

  # Until there's no nice date picking tool let's check if meeting has proper start-end times
  def cannot_end_before_start
    if starts_at_changed? || ends_at_changed?
      if starts_at >= ends_at
        errors.add(:ends_at, '- You can\'t finish meeting before it starts :)' )
      end
    end
  end
end
