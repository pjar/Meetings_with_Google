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

  # it allows tracking changes in models - see declaration of validations
  include ActiveModel::Dirty

  has_many    :participations
  has_many    :users, :through => :participations
  belongs_to  :tutor, :class_name => "User"

  attr_accessible :starts_at, :ends_at, :title, :description,
                  :place, :tutor, :available_places, :total_places,
                  :google_event_id, :google_sync_status

  validate  :dates_cannot_collide
  validate  :cannot_end_before_start


##############################################

### CREATING Meeting

  ## uses a method to construct proper params - it's due ugly datetime select in new_meeting form
  def self.new_meeting(params)
    params = ends_at_param_builder(params)
    Meeting.new(params)
  end

### end of CREATING Meeting

##############################################


##############################################

### READING Meeting

  def self.find_meeting(params)
    @meeting ||= Meeting.find(params)
  end

### end of READING Meeting


##############################################

### UPDATING Meeting

  ## uses a method to construct proper params - it's due ugly datetime select in update_meeting form

  def update_meeting_attrs(params)
    params = ends_at_param_builder(params)
    self.update_attributes(params)
  end

### end of UPDATING Meeting



#### Date formatting

  def start_day
    self.starts_at.strftime("%d %b")
  end

  def start_time
    self.starts_at.to_s(:time)
  end


  def end_time
    self.ends_at.to_s(:time)
  end

#  def duration
#    distance_of_time_in_words(self.starts_at, self.ends_at)
#  end

#### end of Date formatting



protected

  # building ends_at date from date only component of starts_at and time only component of ends_at
  # it's used to simplify meeting creation form

  #

  # I know it's ridiculous to have 2 same methods - I still don't get how to operate
  # properly with self
  def self.ends_at_param_builder(params)
    if !params["ends_at(1i)"].nil?
      params["ends_at(1i)"] = params["starts_at(1i)"]
      params["ends_at(2i)"] = params["starts_at(2i)"]
      params["ends_at(3i)"] = params["starts_at(3i)"]
      params["ends_at(4i)"] = params["ends_at(4i)"]
      params["ends_at(5i)"] = params["ends_at(5i)"]
    end
    params
  end

  def ends_at_param_builder(params)
    if !params["ends_at(1i)"].nil?
      params["ends_at(1i)"] = params["starts_at(1i)"]
      params["ends_at(2i)"] = params["starts_at(2i)"]
      params["ends_at(3i)"] = params["starts_at(3i)"]
      params["ends_at(4i)"] = params["ends_at(4i)"]
      params["ends_at(5i)"] = params["ends_at(5i)"]
    end
    params
  end

  def self.places
    places = []
    Meeting.all.collect {|m| places << m.place}
    places.uniq
  end


### Validations

  # Check if there is no other meeting in that time
  def dates_cannot_collide

    # let's check if date has changed - if no dont bother with validation
    # it was causing problems otherwise
    # SOLVED by simply checking the id of meeting.....
    #if starts_at_changed? || ends_at_changed?
      Meeting.all.each do |meeting|
        if !id.eql?(meeting.id)
          if place.eql?(meeting.place)
            # does it start within other meeting time?
            if starts_at >= meeting.starts_at && starts_at <= meeting.ends_at
              errors.add(:starts_at,  ' - There is another meeting between ' +
                         meeting.starts_at.strftime("%R") +
                                           meeting.ends_at.strftime("-%R"))

            # does it end within other meeting time?
            elsif ends_at >= meeting.starts_at && ends_at <= meeting.ends_at
              errors.add(:ends_at,  ' - There is another meeting between ' +
                            meeting.starts_at.strftime("%R") +
                                             meeting.ends_at.strftime("-%R"))

            # does it run through other meeting time?
            elsif starts_at <= meeting.starts_at && ends_at >= meeting.ends_at
              errors.add(:starts_at, ' - There is another meeting between ' +
                            meeting.starts_at.strftime("%R") +
                                             meeting.ends_at.strftime("-%R"))
            end
          end
        end
      end
    #end
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



