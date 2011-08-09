class ApplicationController < ActionController::Base
  protect_from_forgery
#  before_filter :clear_location


  include SessionsHelper

  private
  def store_location
    session[:previous_location] ||= request.referer
    puts "!!! store_location " + session[:previous_location].inspect.to_s
    session[:previous_location]
  end

  def clear_location
    session[:previous_location] = nil
    puts "!!! clear_location " + session[:previous_location].inspect.to_s
  end

end
