class SignupsController < ApplicationController
  # GET /signups
  # GET /signups.xml

  before_filter :login_required, :except=>[:new, :create, :show]
  
  def index
    @signups = Signup.find(:all)
    render :layout=>'application'
  end

  # GET /signups/1
  # GET /signups/1.xml
  def show
    @signup = Signup.find(params[:id])
    render :layout=>'application'

  end

  # GET /signups/new
  # GET /signups/new.xml
  def new
    @signup = Signup.new
    render :layout=>'application'
  end

  # GET /signups/1/edit
  def edit
    @signup = Signup.find(params[:id])
  end

  # POST /signups
  # POST /signups.xml
  def create
    @signup = Signup.new(params[:signup])

      if @signup.save
        flash[:notice] = 'Signup was successfully created.'
        redirect_to(@signup) 
      else
        @error = 'true'
        render :action => "new", :layout=>'application'
      end
  end

  # PUT /signups/1
  # PUT /signups/1.xml
  def update
    @signup = Signup.find(params[:id])

    respond_to do |format|
      if @signup.update_attributes(params[:signup])
        flash[:notice] = 'Signup was successfully updated.'
        format.html { redirect_to(@signup) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @signup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /signups/1
  # DELETE /signups/1.xml
  def destroy
    @signup = Signup.find(params[:id])
    @signup.destroy

    respond_to do |format|
      format.html { redirect_to(signups_url) }
      format.xml  { head :ok }
    end
  end
end
