# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#


class User < ActiveRecord::Base
  attr_accessible :name, :email


  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i


  validates :name, :length => {:maximum => 50}
  validates :email, :presence => true, :length => {:maximum => 255}, :format => EMAIL_REGEX,
              :uniqueness => {:case_sensitive => false}

end


