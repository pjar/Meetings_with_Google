module MeetingsHelper
  def meeting_or_participation(meeting)
    if admin?
      meeting
    else
      new_participation_path( :meeting_id => meeting.id )
    end
  end

  def participation_params(meeting, host)
    {:controller => "participations", :action => "create", :user_as_host => host, :meeting_id => meeting.id, :user_id => session[:user_id]}
  end
end

