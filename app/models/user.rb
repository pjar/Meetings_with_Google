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

  has_many  :participations
  has_many  :meetings, :through => :participations
  has_many  :lectures, :class_name => "Meeting"

  attr_accessible :name, :email


  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i


  validates :name, :length => {:maximum => 50}
  validates :email, :presence => true, :length => {:maximum => 255}, :format => EMAIL_REGEX,
              :uniqueness => {:case_sensitive => false}

##############################################

### CREATING User

  def self.new_user
    User.new
  end

  def self.new_user_with_params(user)
    User.new(user)
  end

### end of CREATING User

##############################################

### READING User

  def self.find_user(user_id)
    User.find(user_id)
  end

  def self.find_all_users
    User.all
  end

### end of READING User

##############################################

### UPDATING User

  def update_user_info(params)
    self.update_attributes(params)
  end

### end of UPDATING User

##############################################

### DESTROYING User

  def destroy_user
    self.destroy
  end

### end of DESTROYING User


##############################################

### Authenticating User



### end of Authenticating User


end


