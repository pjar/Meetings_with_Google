# == Schema Information
#
# Table name: participations
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  meeting_id :integer
#  comments   :text
#  created_at :datetime
#  updated_at :datetime
#

class Participation < ActiveRecord::Base

  belongs_to  :user
  belongs_to  :meeting

  attr_accessor :user_id, :meeting_id

end


