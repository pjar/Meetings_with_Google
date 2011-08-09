class SessionsController < ApplicationController



  def new
    store_location

  end

  def create
    sign_in( User.find_user(params[:session][:user_id]) )
    redirect_to users_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_location
  end

end
