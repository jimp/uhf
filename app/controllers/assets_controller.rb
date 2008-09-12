
require 'aws/s3'

class AssetsController < ApplicationController
  before_filter :login_required
  before_filter :set_page_template

  def s3_connect
    AWS::S3::Base.establish_connection!(
       :access_key_id     => '15NEVED8T6STXY30F1G2',
       :secret_access_key => '79z/bteyWgqCuzVQUzv+moBXdqlYG2T/WL6B4Sh0') 
  end

  def set_page_template
    @page_template = 'admin'
  end
  protected :set_page_template

  def images
    @assets = Asset.find :all, :conditions=>"content_type in('image/jpeg', 'image/png', 'image/gif') and parent_id is null", :order=>'created_at DESC'
    @target_id = params[:target_id]
    respond_to do |format|
      format.html # images.erb
      format.js  { 
        render :action=>'images.html.erb', :layout=>false
      }
    end
  end
  
  # GET /assets
  # GET /assets.xml
  def index
    # Dir.chdir("#{RAILS_ROOT}/public/upload")
    # @files = Dir.glob("*") || Array.new
    
    s3_connect
    @files = []
    AWS::S3::Bucket.find('uhf.jasperdesign.com').each {|b| @files << b.key }
    
    
    # @assets = assets.find(:all)

    # respond_to do |format|
    #   format.html # index.rhtml
    # end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
    end
  end

  # GET /assets/new
  def new
    # @asset = assets.build
  end

  # GET /assets/1;edit
  def edit
  end

  # POST /assets
  # POST /assets.xml
  def create
    File.open("#{RAILS_ROOT}/public/upload/#{params[:asset][:uploaded_data].original_filename()}", "wb") do |f| 
      f.write(params[:asset][:uploaded_data].read)
    end
    
    index
    render :action => "index" 
    return
    
    @asset = assets.build(params[:asset])

    respond_to do |format|
      if @asset.save
        flash[:notice] = 'Asset was successfully created.'
        format.html { redirect_to asset_url(@asset) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        flash[:notice] = 'Asset was successfully updated.'
        format.html { redirect_to asset_url(@asset) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    File.delete("#{RAILS_ROOT}/public/upload/#{params[:id]}")
    index
    render :action => "index" 
  end


  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    # @asset.destroy

    # respond_to do |format|
    #   format.html { redirect_to assets_url() }
    # end
  end
end
