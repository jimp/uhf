class ContentBlocksController < ApplicationController
  before_filter :login_required
  before_filter :set_page_template
  before_filter :set_redirect, :except=>[:index]

  def set_page_template
    @page_template = 'admin'
  end
  protected :set_page_template
  
  # GET /content_blocks
  # GET /content_blocks.xml
  def index
    @content_blocks = ContentBlock.find(:all)

    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /content_blocks/1
  # GET /content_blocks/1.xml
  def show
    @content_block = ContentBlock.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
    end
  end

  # GET /content_blocks/new
  def new
    @no_sidebar = true
    
    @content_block = ContentBlock.new(:group=>params[:group], :blockable_id=>params[:blockable_id], :blockable_type=>params[:blockable_type].classify)
  end

  # GET /content_blocks/1/edit
  def edit
    @no_sidebar = true
    @content_block = ContentBlock.find params[:id]

    respond_to do |format|
      format.html
      format.js do
        render :partial=>'edit'
      end
    end

  end

  # POST /content_blocks
  # POST /content_blocks.xml
  def create
    @content_block = ContentBlock.new(params[:content_block])
    @content_block.blockable_type=params[:blockable_type].classify
    @content_block.blockable_id=params[:blockable_id]
    @content_block.group=params[:group]

    respond_to do |format|
      if @content_block.save
        flash[:notice] = 'Content Block was successfully created.'
        format.html { redirect }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /content_blocks/1
  # PUT /content_blocks/1.xml
  def update
    @content_block = ContentBlock.find(params[:id])

    respond_to do |format|
      if @content_block.update_attributes(params[:content_block])        
        flash[:notice] = 'ContentBlock was successfully updated.'
        format.html { redirect }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /content_blocks/1
  # DELETE /content_blocks/1.xml
  def destroy
    @content_block = ContentBlock.find(params[:id])
    @content_block.destroy

    respond_to do |format|
      format.html { redirect }
    end
  end
  
  protected
  def redirect
    redirect_to @redirect
  end
  def set_redirect
    if params[:return_url]
      @redirect = params[:return_url]
    elsif params[:blockable_type]=='pages'
      @redirect = Page.find(params[:blockable_id]).url
    else
      @redirect = "/#{params[:blockable_type]}/#{params[:blockable_id]}"
    end
  end
end
