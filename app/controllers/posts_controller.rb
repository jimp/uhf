class PostsController < ApplicationController
  before_filter :login_required
  before_filter :set_page_template

  def set_page_template
    @page_template = 'admin'
  end
  protected :set_page_template

  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.paginate(:page=>params[:page], :order=>'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/search?q=
  # searches the posts using a ferret index
  def search
    unless params[:q].blank?
      @posts=Post.paginate_search(params[:q],:page=>params[:page])
    else
      flash[:notice]='Please Specify a Search Term'
    end
    @search=true
    render :action=>'index'
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    @publish = false

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @publish = !@post.published_at.nil?
  end

  # POST /posts
  # POST /posts.xml
  def create
    @publish=params[:post][:publish]=="1" ? true : false
    @post = Post.new(params[:post].merge(:publish=>@publish))

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(posts_url) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @publish=params[:post][:publish]=="1" ? true : false
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post].merge(:publish=>@publish))
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(posts_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
