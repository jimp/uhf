class PagesController < ApplicationController
  before_filter :login_required, :except=>[:show, :popup, :email, :sitemap, :moving_to_dropdown, :moving_selected, :moving_button, :caregivers_item, :providers_item]
  before_filter :set_page_template, :except=>[:show, :popup, :email, :sitemap, :moving_to_dropdown, :moving_selected]

  def set_page_template
    @page_template = 'admin'
  end
  protected :set_page_template

  # searches the pages using a ferret index
  def search
    unless params[:q].blank?
      ensure_homepage
      term = "*#{params[:q].split.join('* OR *')}*"
      @pages=Page.paginate_search(term,:page=>params[:page])
    else
      flash[:notice]='Please Specify a Search Term'
    end
    @search=true
    render :action=>'index'
  end

  # GET /pages
  def index
    @no_sidebar = true
    @pages=Page.paginate(:order=>'lft, path', :page=>params[:page])
  end

  # GET /pages/tree
  def tree
  end

  # GET /email?u=<url>
  # Shows the email page
  # params[:u] has the url
  def email
    # If there is no url passed in, this will fail, so just redirect to the homepage
    redirect_to "/" and return if params[:u].blank?
    if request.post?
      @message = Message.new(params[:message])
      @message.subject = "#{@message.from} has sent you a page from the NORC Blueprint Website"
      if @message.save
        SiteMailer.deliver_page(@message, "http://#{request.host_with_port}#{params[:u]}")
        flash[:notice] = "Your message was sent successfully"
        redirect_to params[:u]
      end
    end
  end
  
  # GET /pages/:id
  # GET /any_other_path_not_already_defined
  # If there are no pages (the site just started), create a new page
  # If there are pages
  #  * and the page is found, show the page
  #  * and the page is not found
  #   * show admins a "new page" dialog (like a wiki)
  #   * show others a "page not found"
  def show
    
    if Page.count==0
      ensure_homepage
    else
      @page = @page || Page.find_by_alias(app_path)
      # TODO: add the ability for the user to choose whether to render the page or use it as a redirect
      #path = @page.path == '/' ? 'index' : @page.path
      #redirect_to @page.url unless path==app_path
    end

    if @page.nil?
      if admin?
        flash[:notice]="The page you requested does not exist.  Would you like to create it?"
        @page = Page.new(:path=>app_path)
        @page_template = "admin"
        render :action=>'new'
      else
        render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
      end
    else
      @app_path=@page.path
      @title = @page.title
      @page_description = @page.description

      # Even though the printable pages are rendered in a different layout
      # they also need a different template, since this template should only
      # have a single column
      
      if params[:print] && params[:print] == "true"
        @page_template = "print"
      elsif @page.url =~ /moving_from_caregivers_menu/
        @page_template = "template_caregivers"
      elsif @page.url =~ /moving_from_providers_menu/
        @page_template = "template_providers"
      else
        @page_template = @page.template.name
      end
        
      # This isn't really necessary, but it makes the print view very clean
      @pages = [@page]

      if params[:popup] && params[:popup] == "true"
        render :action => "show", :layout => false
      end 

      if params[:save] && params[:save] == "true"
        render_for_save
      end 
      
      #Setting the body_id to caregivers to access Noah's customized css. 
      #Setting the body_id to caregivers to access Noah's customized css. 
      if @page.template.name == 'template_caregivers'
        @body_id = "Caregivers" 
        @other_perspective, @other_persepective_title = 'moving_from_providers_menu' + $1, 'Health Care Provider Perspective' if @page.url =~  /moving_from_caregivers_menu(.*)/
      elsif @page.template.name == 'template_providers'
        @body_id = "Providers" 
        @other_perspective, @other_persepective_title =  'moving_from_caregivers_menu' + $1, 'Family Caregiver Perspective' if @page.url =~ /moving_from_providers_menu(.*)/
      elsif @page.template.name == 'template_caregivers_no_menu'
        @body_id = "Caregivers" 
      elsif @page.template.name == 'template_providers_no_menu'
        @body_id = "Providers" 
      elsif @page.template.name == 'template_index'
        @body_id = "Home" 
      end
      
      @left_top_menu = Page.find_by_path 'left_top_menu' 
      @left_bottom_menu = Page.find_by_path 'left_bottom_menu' 
      
      
      @page_template, @page_type = 'template_pdf', 1 if @page.path == 'CaregiverTool'
      @page_template, @page_type = 'template_pdf', 2 if @page.path == 'ProviderTool'
          
    end
  end

  def moving_button
    @enabled = 'true'
    render :partial=>'site_specific/moving_button' 
  end
  
  def caregivers_item  
    from = Page.find(params['fromplace']).path
    to = Page.find(params['toplace']).path
    path = "moving_from_caregivers_menu/#{from}/#{to}"
    @page = Page.find_by_alias path
    @page.template.name = 'template_caregivers'
    show
  end
  
  def providers_item  
    from = Page.find(params['fromplace']).path
    to = Page.find(params['toplace']).path
    path = "moving_from_providers_menu/#{from}/#{to}"
    @page = Page.find_by_alias path
    @page.template.name = 'template_providers'
    show
  end
  
  def moving_selected
    from = Page.find(params['fromplace']).path
    to = Page.find(params['toplace']).path
    path = "moving_from_caregivers_menu/#{from}/#{to}"
    @page = Page.find_by_alias path
    show
  end
  
  #the moving dropdown has been selected
  def moving_to_dropdown
    @menu = Page.find_by_id(params['id']) unless params['id'] == -1
    render :partial => 'site_specific/moving_to'
  end

  def render_for_save
    # Get the string that represents this page
    @page_template = 'save'
    # Save the info to a string so we can modify it
    @data = render_to_string :action => "show", :layout => true
    render :text => @data
    
    #display the pictures in the correct place
    #@data.gsub!(/src="\/uploads\/Image/, "src=\"http:\/\/#{request.host_with_port}/uploads/Image")
    
    send_data @data, :filename=> 'save_file.html'    
  end  
  
  # GET /pages/new
  def new
    @page=Page.new
    @categories = []
  end

  # GET /pages/1/add_child
  def add_child
    @parent = Page.find(params[:id])
    @page=Page.new(:parent_page_id=>@parent.id, :partial_id => @parent.partial_id)
    @no_sidebar = true
    render :action=>'new'
  end

  # GET /pages/1/move_left
  def move_left
    @page=Page.find(params[:id])
    success = @page.move_left!
    flash[:notice]=success ? "#{@page.link_text} has been moved successfully" : "#{@page.link_text} cannot be moved up any more"
    redirect_to pages_url
  end

  # GET /pages/1/move_left
  def move_right
    @page=Page.find(params[:id])
    success = @page.move_right!
    flash[:notice]=success ? "#{@page.link_text} has been moved successfully" : "#{@page.link_text} cannot be moved down any more"
    redirect_to pages_url
  end

  # POST /pages
  # This is a bit convoluted, because acts_as_nested_set does not allow you to assign a parent_id
  # What happens here is:
  #  * it grabs the parent_page_id from the form
  #  * it saves and tries to move the record if there is a page to move to
  #  * if the move fails, the saved record is deleted, and the form is returned
  def create
    # populate_categories
    @page = Page.new(params[:page])
    @parent = @page.parent_page_id.blank? ? nil : Page.find(@page.parent_page_id)   
    if @page.save
      begin
        unless @parent.nil?
          @page.move_to_child_of(@parent)
          Alias.update
        end
        flash[:notice]='Page was created successfully'
        redirect_to pages_url
      rescue
        @clone=@page.clone
        @page.destroy
        @page=@clone
        @page.valid?
        @page.errors.add(:path,'has already been taken')
        render :action=>'new'
      end

      add_categories_to_pages

    else
      render :action=>'new'
    end
  end

  # GET /pages/1/edit
  def edit
    @no_sidebar = true
    @page = Page.find(params[:id])
    # @categories = @page.categories.map(&:id).map(&:to_s)
    @parent = @page.parent
    @page.parent_page_id=@parent.id unless @page.path=='index' || @parent.nil?
    respond_to do |format|
      format.html
    end
  end

  # PUT /pages/1
  def update
    # populate_categories
    @page = Page.find(params[:id])
    respond_to do |format|
      if @page.update_attributes(params[:page])
        begin
          unless @page.parent_page_id.to_s == @page.parent_id.to_s
            @parent = @page.parent_page_id.blank? ? Page.find(:first) : Page.find(@page.parent_page_id)   
            @page.move_to_child_of(@parent)
            Alias.update
          end
          flash[:notice] = 'Page was successfully updated.'
          format.html { redirect_to pages_url }
        rescue
          @page.valid?
          @page.errors.add(:parent_id,'you specified cannot become the parent of this page')
          @page.parent_page_id = @page.parent_id
          format.html { render :action => "edit" }
        end

        add_categories_to_pages

      else
        format.html { render :action => "edit" }
      end
    end    
  end

  # DELETE /pages/1
  def destroy
    @page = Page.find(params[:id])
    respond_to do |format|
      if @page.path=='index'
        format.html do
          flash[:notice]="You cannot delete the home page!"
          redirect_to pages_url 
        end
      else
        @page.destroy
        format.html do
          flash[:notice]="Page was deleted successfully."
          redirect_to pages_url 
        end
      end
    end
  end

  # GET /sitemap
  # Displays all of the pages, along with their link text
  def sitemap
    @pages = Page.sitemap
  end

  protected

  def populate_categories
    # @categories = []
    # params[:category].each do |id, value|
    #   @categories << id
    # end if params[:category]
  end

  def add_categories_to_pages
    # @page.page_categories.clear
    # @categories.each do |category|
    #   @page.page_categories.create(:category_id => category)
    # end
  end

  # a useful method for ensuring there is always home page available
  def ensure_homepage
    @page=Page.find_or_create_by_path_and_title(:path=>'index',:title=>'Home Page')
    @page.save
  end

end
