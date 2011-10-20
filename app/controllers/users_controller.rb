class UsersController < ApplicationController

  #before_filter :authorize_admin, :except => [:new, :create]

  # GET /users
  # GET /users.xml
  def index
    @users ||= User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user ||= User.find_user(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user ||= User.new_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user ||= User.find_user(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user ||= User.new_user_with_params(params[:user])

    respond_to do |format|
      if @user.save
        if admin?
          format.html { redirect_to(users_path, :notice => 'User was successfully created.') }
          format.xml  { render :xml => @user, :status => :created, :location => users_path }
        else
          sign_in @user
          format.html { redirect_to(@user, :notice => 'User was successfully created.') }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        end

      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user ||= User.find_user(params[:id])

    respond_to do |format|
      if @user.update_user_info(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find_user(params[:id])
    @user.destroy_user

    respond_to do |format|
      format.html { redirect_to(users_url, :notice => 'User was successfully deleted') }
      format.xml  { head :ok }
    end
  end
end
