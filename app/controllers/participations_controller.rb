class ParticipationsController < ApplicationController

  before_filter :authorize_user

  def new
    @participation = Participation.new
    #@user_note = @participation.build_user_note

    @meeting = Meeting.find(params[:meeting_id])
    @user = User.find(session[:user_id])
    @user_as_host = params[:user_as_host]


    respond_to do |format|

      format.html
      format.xml  { render :xml => @participation }
    end
  end

  def create
    @participation = Participation.new
    respond_to do |format|
      if @participation.create_participation( params[:meeting_id], params[:user_id],
                                         params[:user_as_host])
        format.html { redirect_to meetings_path}
        format.xml  { render :xml => @participation }
      else
        format.html { redirect_to meetings_path, :notice => "You already have meeting at that time"}
        format.xml  { render :xml => @participation.errors, :status => :unprocessable_entity }

      end
    end
  end

  def index
    if signed_in?
      @user = User.find(session[:user_id])
     #@meetings = @user.meetings.all_active
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      @participations = Participation.where( :user_id => @user )
      @meetings ||= @user.meetings.all_active.ordered.by_month( @date )
    else
      respond_to do |format|

        format.html { redirect_to meetings_path}
        format.xml  { head :ok}
      end
    end
  end

  def destroy
    @participation = Participation.find_participation(params[:meeting_id], params[:user_id])
    @participation.destroy_participation
    respond_to do |format|

      format.html { redirect_to meetings_path}
      format.xml  { head :ok}
    end
  end

  def update
    @participation = Participation.find_participation( params[:meeting_id], params[:user_id] )

  end

  def show
    puts "dupa"
  end

end
