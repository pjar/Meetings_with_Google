require 'spec_helper'

describe Meeting do
#  pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
    @meeting_attr = {

        :starts_at    =>  "2011-08-08 21:00",
        :ends_at      =>  "2011-08-08 22:00",
        :title        =>  "Spotkanie organizacyjne",
        :description  =>  "Pierwsze spotkanie",
        :place        =>  "Sala konferencyjna",
        :total_places =>  4

    }
  end

  it "should create a new instance given valid attributes" do
    Meeting.create!(@meeting_attr)
  end

  it "should reject meetings that have colliding dates with other meetings" do
    Meeting.create!(@meeting_attr)

    starts_at_times = ["20:00", "21:00", "21:30"]
    ends_at_times   = ["21:00", "22:00", "22:30"]
    starts_at_date  = "2011-08-08 "
    ends_at_date    = "2011-08-08 "

    starts_at_times.each_with_index do |start_time,i|
      date1 = ""
      date2 = ""
      date1 << starts_at_date << start_time
      date2 << ends_at_date   << ends_at_times[i]
      meeting_with_colliding_date = Meeting.new(@meeting_attr.merge(:starts_at => date1, :ends_at => date2))
      meeting_with_colliding_date.should_not be_valid

    end
  end

  it "should reject meetings that end before start" do
    bad_date = "2011-08-08 20:59"
    meeting_that_ends_before_start = Meeting.new(@meeting_attr.merge(:ends_at => bad_date))
    meeting_that_ends_before_start.should_not be_valid
  end

end






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

