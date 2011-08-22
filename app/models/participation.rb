# == Schema Information
#
# Table name: participations
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  meeting_id   :integer
#  comments     :text
#  created_at   :datetime
#  updated_at   :datetime
#  user_as_host :boolean
#


class Participation < ActiveRecord::Base

  belongs_to  :user
  belongs_to  :meeting

  attr_accessor :user_id, :meeting_id

  validate  :no_double_users
  # validate  :no_colliding_meetings_for_user

  def create_participation( meeting_id, user_id, user_as_host)

    if user_as_host
      self.user_as_host = user_as_host
    else
      self.user_as_host = false
    end

    @user = User.find(user_id)
    @user.participations << self

    @meeting = Meeting.find(meeting_id)
    @meeting.participations << self

#### !!!! TODO:Change it! Very primitive validation for Participation
    Participation.all.each do |p|
      if self.user.eql?(p.user)
        if !self.meeting.eql?(p.meeting)
          if self.meeting.starts_at >= p.meeting.starts_at && self.meeting.starts_at <= p.meeting.ends_at
            self.destroy
            return false
            # does it end within other meeting time?
            elsif self.meeting.ends_at >= p.meeting.starts_at && self.meeting.ends_at <= p.meeting.ends_at
              self.destroy
              return false
            # does it run through other meeting time?
            elsif self.meeting.starts_at <= p.meeting.starts_at && self.meeting.ends_at >= p.meeting.ends_at
              self.destroy
              return false
          end
        end
      end
    end
################################### End of PRIMITIVE VALIDATION #######################

    self.save
    true
  end


  def self.find_participation(meeting_id, user_id)
    Participation.where(:meeting_id => meeting_id, :user_id => user_id).first
  end

  def destroy_participation
    meeting = self.meeting
    user = self.user
    self.destroy
    meeting.participations(true)
    user.participations(true)
  end

protected

  def no_double_users
    Participation.all.each do |p|
      if user.eql?(p.user) & meeting.eql?(p.meeting)
        errors.add(:user, "User already participates in that meeting!")
      end
      end
  end

  def no_colliding_meetings_for_user
  #  Participation.all.each do |p|
  #    if user.eql?( p.user )
  #     if !meeting.eql?(p.meeting)
  #        puts "!!! Validation !!! id: " + meeting.id.to_s
  #      end
   #     user.meetings.each do |meet|
   #         puts "!!! FOUND TWO SAME MEETINGS !!!"
   #         if p.meeting.starts_at >= meet.starts_at && p.meeting.starts_at <= meet.ends_at
   #               errors.add(:user,  ' - You have another meeting between ' +
   #                          meet.starts_at.strftime("%R") +
   #                                           meet.ends_at.strftime("-%R"))
   #
   #         # does it end within other meeting time?
   #         elsif p.meeting.ends_at >= meet.starts_at && p.meeting.ends_at <= meet.ends_at
   #               errors.add(:user,  ' - You have another meeting between ' +
   #                             meet.starts_at.strftime("%R") +
   #                                              meet.ends_at.strftime("-%R"))
   #
   #         # does it run through other meeting time?
   #         elsif p.meeting.starts_at <= meet.starts_at && p.meeting.ends_at >= meet.ends_at
   #               errors.add(:user, ' - You have another meeting between ' +
   #                             meet.starts_at.strftime("%R") +
   #                                              meet.ends_at.strftime("-%R"))
   #         end
   #     end
   #   end
   # end
   # Participation.all.each do |p|
   #   if meeting.eql?(p.meeting)
   #     if user.eql?(p.user)
   #       puts "!!! Meeting !!! id: " + meeting.ends_at.to_s
   #       puts "!!! User !!! id: " + user.id.to_s
   #       puts "!!! Participation !! id: " + id.to_s + " p.id: " + p.id.to_s
   #       errors.add(:user, 'Dupa')
   #     end
   #   end
   # end
   # puts "!!! Meeting.id: " + meeting.object_id.to_s
  end

end


