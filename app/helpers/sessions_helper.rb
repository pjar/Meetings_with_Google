module SessionsHelper



  def sign_in(user)
    session[:user_id] = user.id
  end

  def signed_in?
    !session[:user_id].nil?
  end

  def admin?
    if session[:user_id].nil?
      false
    else
     User.find(session[:user_id]).name.eql?("Admin")
     #User.where(:id => session[:user_id]).name.eql?("Admin")
    end
  end

  def authorize_admin
    unless admin?
      flash[:notice] = "You need to sign in as Admin to view this resource"
      redirect_to root_path_path
      false
    end
  end

  def authorize_user
    unless signed_in?
      redirect_to home_path
    end
  end

private

  def current_user(user_id)
    if session[:user_id].nil?
      false
    else
      session[:user_id] == user_id
    end

  end


end
