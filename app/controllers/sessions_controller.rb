class SessionsController < ApplicationController



  def new
    #store_location
    session[:previous_page] = request.referer

  end

  def create
    sign_in( User.find_user(params[:session][:user_id]) )
    where_to_redirect = session[:previous_page]
    session[:previous_page] = nil
    redirect_to where_to_redirect.nil? ? root_path  : where_to_redirect
  end

  def destroy
   # store_location
    session[:user_id] = nil
    redirect_to request.referer.nil? ? root_path : request.referer
  end

end
