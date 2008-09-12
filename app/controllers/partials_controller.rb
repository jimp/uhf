class PartialsController < ApplicationController
  before_filter :login_required
  before_filter :set_page_template

  # GET /partials
  # GET /partials.xml
  def index
    @partials = Partial.find(:all, :order => "position")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @partials }
    end
  end

  # GET /partials/1
  # GET /partials/1.xml
  def show
    @partial = Partial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @partial }
    end
  end

  # GET /partials/new
  # GET /partials/new.xml
  def new
    @partial = Partial.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @partial }
    end
  end

  # GET /partials/1/edit
  def edit
    @partial = Partial.find(params[:id])
  end

  # POST /partials
  # POST /partials.xml
  def create
    @partial = Partial.new(params[:partial])

    respond_to do |format|
      if @partial.save
        flash[:notice] = 'Partial was successfully created.'
        format.html { redirect_to(partials_path) }
        format.xml  { render :xml => @partial, :status => :created, :location => @partial }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @partial.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /partials/1
  # PUT /partials/1.xml
  def update
    @partial = Partial.find(params[:id])

    respond_to do |format|
      if @partial.update_attributes(params[:partial])
        flash[:notice] = 'Partial was successfully updated.'
        format.html { redirect_to(partials_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @partial.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /partials/1
  # DELETE /partials/1.xml
  def destroy
    @partial = Partial.find(params[:id])
    @partial.destroy

    respond_to do |format|
      format.html { redirect_to(partials_url) }
      format.xml  { head :ok }
    end
  end
end
