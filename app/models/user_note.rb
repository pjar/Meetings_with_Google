class UserNote < ActiveRecord::Base

  belongs_to   :participation

  validates :note, :length => { :maximum => 1024 }

  attr_accessor :note

end
