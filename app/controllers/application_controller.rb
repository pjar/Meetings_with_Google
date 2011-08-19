class ApplicationController < ActionController::Base
  protect_from_forgery
#  before_filter :clear_location


include SessionsHelper

protected

  def authorize_admin
    unless admin?
      flash[:notice] = "You need to sign in as Admin to view this resource"
      redirect_to home_path
      false
    end
  end

private
  def store_location
    if !request.referer.include?(signin_path)
      session[:previous_location] = request.referer
    elsif !request.referer.include?((sessions_path) || (sigout_path))
      session[:previous_location] = nil
    end
  end

  def clear_location
    session[:previous_location] = nil
  end

end
