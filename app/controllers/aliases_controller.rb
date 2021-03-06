class AliasesController < ApplicationController
  before_filter :login_required
  before_filter :set_page_template

  def set_page_template
    @page_template = 'admin'
  end
  protected :set_page_template
  
  # GET /aliases
  # GET /aliases.xml
  def index
    @aliases = Alias.paginate(:page=>params[:page], :per_page=>30)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aliases }
    end
  end

  # GET /aliases/1
  # GET /aliases/1.xml
  def show
    @alias = Alias.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @alias }
    end
  end

  # GET /aliases/new
  # GET /aliases/new.xml
  def new
    @alias = Alias.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @alias }
    end
  end

  # GET /aliases/1/edit
  def edit
    @alias = Alias.find(params[:id])
  end

  # POST /aliases
  # POST /aliases.xml
  def create
    @alias = Alias.new(params[:alias])

    respond_to do |format|
      if @alias.save
        flash[:notice] = 'Alias was successfully created.'
        format.html { redirect_to(aliases_url) }
        format.xml  { render :xml => @alias, :status => :created, :location => @alias }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aliases/1
  # PUT /aliases/1.xml
  def update
    @alias = Alias.find(params[:id])

    respond_to do |format|
      if @alias.update_attributes(params[:alias])
        flash[:notice] = 'Alias was successfully updated.'
        format.html { redirect_to(aliases_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aliases/1
  # DELETE /aliases/1.xml
  def destroy
    @alias = Alias.find(params[:id])
    @alias.destroy

    respond_to do |format|
      format.html { redirect_to(aliases_url) }
      format.xml  { head :ok }
    end
  end
end
