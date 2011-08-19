class ApplicationController < ActionController::Base
  protect_from_forgery
#  before_filter :clear_location


  include SessionsHelper

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
