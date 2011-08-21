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

    self.save
  end

end


