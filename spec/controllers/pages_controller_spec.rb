require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController, "#route_for" do

  it "should map { :controller => 'pages', :action => 'index' } to /pages" do
    route_for(:controller => "pages", :action => "index").should == "/pages"
  end
  
  it "should map { :controller => 'pages', :action => 'new' } to /pages/new" do
    route_for(:controller => "pages", :action => "new").should == "/pages/new"
  end
  
  it "should map { :controller => 'pages', :action => 'show', :id => 1 } to /pages/1" do
    route_for(:controller => "pages", :action => "show", :id => 1).should == "/pages/1"
  end
  
  it "should map { :controller => 'pages', :action => 'edit', :id => 1 } to /pages/1/edit" do
    route_for(:controller => "pages", :action => "edit", :id => 1).should == "/pages/1/edit"
  end
  
  it "should map { :controller => 'pages', :action => 'update', :id => 1} to /pages/1" do
    route_for(:controller => "pages", :action => "update", :id => 1).should == "/pages/1"
  end
  
  it "should map { :controller => 'pages', :action => 'destroy', :id => 1} to /pages/1" do
    route_for(:controller => "pages", :action => "destroy", :id => 1).should == "/pages/1"
  end

  it "should map { :controller => 'pages', :action => 'search'} to /pages/search" do
    route_for(:controller => "pages", :action => "search").should == "/pages/search"
  end
  
end

describe PagesController, "handling GET /pages" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @page = mock_model(Page)
    Page.stub!(:find).and_return([@page])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all pages" do
    do_get
  end
  
  it "should assign the found pages for the view" do
    do_get
    assigns[:pages].should == [@page]
  end
end

describe PagesController, "handling GET /pages/1 with a 0 page count" do

  before do
    Page.stub!(:count).and_return(0)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
    
  it "should assign the found page for the view" do
    do_get
    assigns[:page].title.should == 'Home Page'
  end
end

describe PagesController, "handling GET /pages/1 with a positive page count, and existing page, as a public user" do

  before do
    @page = mock_model(Page, :path=>'index')
    @page.should_receive(:title)
    @page.should_receive(:description)
    Page.stub!(:find_by_alias).and_return(@page)
    Page.stub!(:count).and_return(1)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the page requested" do
    Page.should_receive(:find_by_alias).and_return(@page)
    do_get
  end
  
  it "should assign the found page for the view" do
    do_get
    assigns[:page].should equal(@page)
  end
end

describe PagesController, "handling GET /pages/1 with a positive page count, and a non-existant page, as a public user" do

  before do
    @controller.should_receive(:admin?).and_return(false)
    @page = mock_model(Page)
    Page.stub!(:find_by_alias).and_return(nil)
    Page.stub!(:count).and_return(1)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.headers["Status"].should == "404 Not Found"
  end
  
  it "should render show template" do
    do_get
    response.should render_template(RAILS_ROOT+'/public/404.html')
  end
    
  it "should assign the found page for the view" do
    do_get
    assigns[:page].should be_nil
  end
end

describe PagesController, "handling GET /pages/1 with a positive page count, and existing page, as an admin user" do

  before do
    @controller.should_receive(:admin?).and_return(true)
    Page.stub!(:find_by_alias).and_return(nil)
    Page.stub!(:count).and_return(1)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('new')
  end
    
  it "should assign the found page for the view" do
    do_get
    assigns[:page].path.should == 'index'
  end
end

describe PagesController, "handling GET /pages/new" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @page = mock_model(Page)
    Page.stub!(:new).and_return(@page)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new page" do
    Page.should_receive(:new).and_return(@page)
    do_get
  end
  
  it "should not save the new page" do
    @page.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new page for the view" do
    do_get
    assigns[:page].should equal(@page)
  end
end

describe PagesController, "handling GET /pages/1/edit" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @page = mock_model(Page, :attributes=>{}, :parent=>@page, :path=>'index')
    Page.stub!(:find).and_return(@page)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the page requested" do
    Page.should_receive(:find).and_return(@page)
    do_get
  end
  
  it "should assign the found Page for the view" do
    do_get
    assigns[:page].should equal(@page)
  end
end

describe PagesController, "handling POST /pages" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @page = mock_model(Page, :to_param => "1", :path=>'new', :parent_page_id=>nil, :destroy=>true, :parent=>nil)
    Page.stub!(:new).and_return(@page)
  end
  
  def post_with_successful_save
    @page.should_receive(:save).and_return(true)
    post :create, :page => {}
  end
  
  def post_with_failed_save
    @page.should_receive(:save).and_return(false)
    post :create, :page => {}
  end
  
  it "should create a new page" do
    post_with_successful_save
  end

  it "should redirect to the new page on successful save" do
    post_with_successful_save
    response.should redirect_to(pages_url)
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe PagesController, "handling PUT /pages/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @page = mock_model(Page, :to_param => "1", :title=>'title', :description=>'desc', :path=>'path', :parent_page_id=>1, :parent_id=>1)
    Page.stub!(:find).and_return(@page)
  end
  
  def put_with_successful_update
    @page.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @page.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the page requested" do
    Page.should_receive(:find).with("1").and_return(@page)
    put_with_successful_update
  end

  it "should update the found page" do
    put_with_successful_update
    assigns(:page).should equal(@page)
  end

  it "should assign the found page for the view" do
    put_with_successful_update
    assigns(:page).should equal(@page)
  end

  it "should redirect to the page on successful update" do
    put_with_successful_update
    response.should redirect_to(pages_url)
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe PagesController, "handling DELETE /pages/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @page = mock_model(Page, :destroy => true, :path=>'somepage')
    Page.stub!(:find).and_return(@page)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the page requested" do
    Page.should_receive(:find).with("1").and_return(@page)
    do_delete
  end
  
  it "should call destroy on the found page" do
    @page.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the pages list" do
    do_delete
    response.should redirect_to(pages_url)
  end
end
