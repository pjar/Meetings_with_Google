module ApplicationHelper
  def this_user
    User.where(:id => session[:user_id]).first
  end
end
