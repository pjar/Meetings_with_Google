class MeetingsController < ApplicationController



  before_filter :authorize_admin, :except  => [:index, :show]

  # GET /meetings
  # GET /meetings.xml
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @meetings ||= Meeting.ordered.by_month( @date )
    if signed_in?
      @user = User.find(session[:user_id])
    end

    respond_to do |format|
      format.html
      format.xml { render :xml => @metings }
      format.js
    end

  end

  # GET /meetings/1
  # GET /meetings/1.xml
  def show
    @meeting = Meeting.find_meeting(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/new
  # GET /meetings/new.xml
  def new
    @meeting = Meeting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # POST /meetings
  # POST /meetings.xml
  def create
    @meeting = Meeting.new_meeting(params[:meeting])

    respond_to do |format|
      if @meeting.save_with_sync
        format.html { redirect_to(meetings_url, :notice => 'Meeting was successfully created.') }
        format.xml  { render :xml => @meeting, :status => :created, :location => @meeting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
      end
    end
  end


  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find(params[:id])
  end


  # PUT /meetings/1
  # PUT /meetings/1.xml
  def update
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      if @meeting.update_attributes_with_sync(params[:meeting])
        format.html { redirect_to(meetings_url, :notice => 'Meeting was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.xml
  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.destroy_and_sync

    respond_to do |format|
      format.html { redirect_to(meetings_url) }
      format.xml  { head :ok }
    end
  end
end
