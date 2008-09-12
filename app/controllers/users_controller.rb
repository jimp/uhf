class UsersController < ApplicationController
  before_filter :login_required
  before_filter :set_page_template
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.paginate(:page=>params[:page], :order=>'login')

    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1;edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    unless params[:user][:password].blank?
      @user.password=params[:user][:password]
      @user.password_confirmation=params[:user][:password_confirmation]
    end
    @user.role_id=params[:user][:role_id]

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to users_url }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    unless params[:user][:password].blank?
      @user.password=params[:user][:password]
      @user.password_confirmation=params[:user][:password_confirmation]
    end
    @user.role_id=params[:user][:role_id]

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to users_url }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end
end
