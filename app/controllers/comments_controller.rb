class CommentsController < ApplicationController
  before_filter :login_required, :only=>[:index, :edit, :update, :destroy]
  before_filter :set_page_template, :only=>[:index, :edit, :update, :destroy]

  def set_page_template
    @page_template = 'admin'
  end
  protected :set_page_template


  # GET /comments
  # GET /comments.xml
  def index
    @comments = []
    case params[:filter]
    when nil
      @comments = Comment.paginate(:page=>params[:page])
    when 'spam'
      @comments = Comment.spam_list(params[:page] || 1)
    when 'unapproved'
      @comments = Comment.unapproved(params[:page] || 1)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    hash = params[:comment].merge(user_variables)
    @comment = Comment.new(hash)
    @comment.commentable = Post.find(params[:post_id]) if params[:post_id]
    @commentable = @comment.commentable
    case @commentable.class.name
    when 'Post'
      @goto_url = @commentable.url
    when 'Organization'
      @goto_url = organization_url(@commentable)
    end

    # TODO: make this a user-defined variable in a global settings table
    @comment.approved_at = Time.now.utc

    respond_to do |format|
      if @comment.save!
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    hash = params[:comment].merge(user_variables)

    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(hash)
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /comments/1/spam
  def spam
    @comment = Comment.find(params[:id])
    @comment.update_attributes(:spam=>true)
    redirect_to comments_url
  end

  # POST /comments/1/ham
  def ham
    @comment = Comment.find(params[:id])
    @comment.update_attributes(:spam=>false)
    redirect_to comments_url
  end

  # POST /comments/1/approve
  def approve
    @comment = Comment.find(params[:id])
    @comment.update_attributes(:approved_at=>Time.now.utc)
    redirect_to comments_url
  end

  # POST /comments/1/disapprove
  def disapprove
    @comment = Comment.find(params[:id])
    @comment.update_attributes(:approved_at=>nil)
    redirect_to comments_url
  end


  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect }
      format.xml  { head :ok }
    end
  end

  protected
  # grabs the user variables to pass to the spam filter
  def user_variables
    {:ip=>request.remote_ip, :user_agent=>request.env['HTTP_USER_AGENT'], :referrer=>request.env['HTTP_REFERER']}
  end

  # checks for the post_id and redirects appropriately
  def redirect
    redirect_to @goto_url
  end
end
