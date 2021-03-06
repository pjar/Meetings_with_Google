require 'spec_helper'

describe User do
#  pending "add some examples to (or delete) #{__FILE__}" -- DONE
  before(:each) do
    @user_attr = { :name => "John Example", :email => "valid@mail.com"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@user_attr)
  end

  it "should require an email" do
    no_email_user = User.new(@user_attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should not accept names longer than 50 characters" do
    long_name = "a" * 51
    long_name_user = User.new(@user_attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@user_attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@user_attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@user_attr)
    user_with_duplicate_email = User.new(@user_attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @user_attr[:email].upcase
    User.create!(@user_attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@user_attr)
    user_with_duplicate_email.should_not be_valid
  end
end



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

