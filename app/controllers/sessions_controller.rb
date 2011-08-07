class SessionsController < ApplicationController
  def new
  end

  def create
    sign_in User.find_user(params[:session][:user_id])
    puts "!!! create " + params[:session][:user_id].inspect.to_s
    redirect_to users_path
  end

  def destroy
    session[:user_id] = nil
    render 'new'
  end

end
