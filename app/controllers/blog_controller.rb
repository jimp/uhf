class BlogController < ApplicationController

  # GET /blog
  # GET /blog.atom
  # GET /blog/2007
  # GET /blog/2007.atom
  # GET /blog/2007/04
  # GET /blog/2007/04.atom
  # GET /blog/2007/04/01
  # GET /blog/2007/04/01.atom
  # GET /blog/2007/04/01/2345
  # GET /blog/2007/04/01/2345.atom
  # This single action defines html pages and feeds for all posts
  # Collections are rendered as such, individual records are rendered with comments
  def index
    respond_to do |format|
      if  params[:id].blank?
        @posts=Post.find_by_date(params[:year], params[:month], params[:day])
        format.html
        format.atom do
          render :action=>'index', :layout=>false
        end
      else
        if @post=Post.published(params[:id])
          format.html
          format.atom do
            render :action=>'post', :layout=>false
          end
        else
          format.html do
            flash[:notice]='The post you were looking for cannot be found'
            redirect_to '/blog'
            return
          end
          format.atom do
            render :nothing=>true
          end
        end
      end
    end
  end

end
