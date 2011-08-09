module SessionsHelper

  def sign_in(user)
    session[:user_id] = user.id
  end

  def signed_in?
    !session[:user_id].nil?
  end

  def admin?
    User.find(session[:user_id]).name.eql?("Admin")
end

  def current_user(user_id)
    session[:user_id] == user_id
  end

end
