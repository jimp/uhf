class RolesController < ApplicationController
  before_filter :login_required
  before_filter :set_page_template

  def set_page_template
    @page_template = 'admin'
  end
  protected :set_page_template
  
  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.find(:all)

    respond_to do |format|
      format.html # index.erb
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.erb
    end
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1;edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        flash[:notice] = 'Role was successfully created.'
        format.html { redirect_to roles_url }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to roles_url }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to roles_url }
    end
  end
end
