class GoogleSynchronizationsController < ApplicationController

  def new
    @sync = GoogleSynchronization.new
    if @sync.upload
      respond_to do |format|
        format.html { redirect_to( meetings_path, :notice => "Sync successful" ) }
      end
    else
      respond_to do |format|
        format.html { redirect_to( meetings_path, :notice => "Sync failed" ) }
      end
    end
  end

  def read_remote_calendar
    @sync ||= GoogleSynchronization.new


      @meetings = @sync.download ? @sync.feed : []

  end

end
