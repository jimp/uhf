class PdfsController < ApplicationController
  # GET /pdfs
  # GET /pdfs.xml
  def index
    @pdfs = Pdfs.find(:all) 
    
    render :layout=>'application', :action=>'index'
  end

  # GET /pdfs/1
  # GET /pdfs/1.xml
  def show
    pdf = Pdfs.find(params[:id])
    send_file pdf.full_filename, :type => 'plain/text', :disposition => 'inline'
  end

  # GET /pdfs/new
  # GET /pdfs/new.xml
  def new
    @pdfs = Pdfs.new
    render :layout=>'application'
  end

  # GET /pdfs/1/edit
  def edit
    @pdfs = Pdfs.find(params[:id])
  end

  # POST /pdfs
  # POST /pdfs.xml
  def create
    @pdfs = Pdfs.new(params[:pdfs])
    @pdfs.save
    index
  end

  # PUT /pdfs/1
  # PUT /pdfs/1.xml
  def update
    @pdfs = Pdfs.find(params[:id])

    respond_to do |format|
      if @pdfs.update_attributes(params[:pdfs])
        flash[:notice] = 'Pdfs was successfully updated.'
        format.html { redirect_to(@pdfs) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pdfs.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pdfs/1
  # DELETE /pdfs/1.xml
  def destroy
    @pdfs = Pdfs.find(params[:id])
    @pdfs.destroy

    respond_to do |format|
      format.html { redirect_to(pdfs_url) }
      format.xml  { head :ok }
    end
  end
end
