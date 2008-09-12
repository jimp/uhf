require File.dirname(__FILE__) + '/../spec_helper'

describe CategoryGroupsController, "#route_for" do

  it "should map { :controller => 'category_groups', :action => 'index' } to /category_groups" do
    route_for(:controller => "category_groups", :action => "index").should == "/category_groups"
  end
  
  it "should map { :controller => 'category_groups', :action => 'new' } to /category_groups/new" do
    route_for(:controller => "category_groups", :action => "new").should == "/category_groups/new"
  end
  
  it "should map { :controller => 'category_groups', :action => 'show', :id => 1 } to /category_groups/1" do
    route_for(:controller => "category_groups", :action => "show", :id => 1).should == "/category_groups/1"
  end
  
  it "should map { :controller => 'category_groups', :action => 'edit', :id => 1 } to /category_groups/1;edit" do
    route_for(:controller => "category_groups", :action => "edit", :id => 1).should == "/category_groups/1;edit"
  end
  
  it "should map { :controller => 'category_groups', :action => 'update', :id => 1} to /category_groups/1" do
    route_for(:controller => "category_groups", :action => "update", :id => 1).should == "/category_groups/1"
  end
  
  it "should map { :controller => 'category_groups', :action => 'destroy', :id => 1} to /category_groups/1" do
    route_for(:controller => "category_groups", :action => "destroy", :id => 1).should == "/category_groups/1"
  end
  
end

describe CategoryGroupsController, "handling GET /category_groups" do

  before do
    @category_group = mock_model(CategoryGroup)
    CategoryGroup.stub!(:find).and_return([@category_group])
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
  
  it "should find all category_groups" do
    CategoryGroup.should_receive(:find).with(:all).and_return([@category_group])
    do_get
  end
  
  it "should assign the found category_groups for the view" do
    do_get
    assigns[:category_groups].should == [@category_group]
  end
end

describe CategoryGroupsController, "handling GET /category_groups.xml" do

  before do
    @category_group = mock_model(CategoryGroup, :to_xml => "XML")
    CategoryGroup.stub!(:find).and_return(@category_group)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all category_groups" do
    CategoryGroup.should_receive(:find).with(:all).and_return([@category_group])
    do_get
  end
  
  it "should render the found category_groups as xml" do
    @category_group.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe CategoryGroupsController, "handling GET /category_groups/1" do

  before do
    @category_group = mock_model(CategoryGroup)
    CategoryGroup.stub!(:find).and_return(@category_group)
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
  
  it "should find the category_group requested" do
    CategoryGroup.should_receive(:find).with("1").and_return(@category_group)
    do_get
  end
  
  it "should assign the found category_group for the view" do
    do_get
    assigns[:category_group].should equal(@category_group)
  end
end

describe CategoryGroupsController, "handling GET /category_groups/1.xml" do

  before do
    @category_group = mock_model(CategoryGroup, :to_xml => "XML")
    CategoryGroup.stub!(:find).and_return(@category_group)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the category_group requested" do
    CategoryGroup.should_receive(:find).with("1").and_return(@category_group)
    do_get
  end
  
  it "should render the found category_group as xml" do
    @category_group.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe CategoryGroupsController, "handling GET /category_groups/new" do

  before do
    @category_group = mock_model(CategoryGroup)
    CategoryGroup.stub!(:new).and_return(@category_group)
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
  
  it "should create an new category_group" do
    CategoryGroup.should_receive(:new).and_return(@category_group)
    do_get
  end
  
  it "should not save the new category_group" do
    @category_group.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new category_group for the view" do
    do_get
    assigns[:category_group].should equal(@category_group)
  end
end

describe CategoryGroupsController, "handling GET /category_groups/1/edit" do

  before do
    @category_group = mock_model(CategoryGroup)
    CategoryGroup.stub!(:find).and_return(@category_group)
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
  
  it "should find the category_group requested" do
    CategoryGroup.should_receive(:find).and_return(@category_group)
    do_get
  end
  
  it "should assign the found CategoryGroup for the view" do
    do_get
    assigns[:category_group].should equal(@category_group)
  end
end

describe CategoryGroupsController, "handling POST /category_groups" do

  before do
    @category_group = mock_model(CategoryGroup, :to_param => "1")
    CategoryGroup.stub!(:new).and_return(@category_group)
  end
  
  def post_with_successful_save
    @category_group.should_receive(:save).and_return(true)
    post :create, :category_group => {}
  end
  
  def post_with_failed_save
    @category_group.should_receive(:save).and_return(false)
    post :create, :category_group => {}
  end
  
  it "should create a new category_group" do
    CategoryGroup.should_receive(:new).with({}).and_return(@category_group)
    post_with_successful_save
  end

  it "should redirect to the new category_group on successful save" do
    post_with_successful_save
    response.should redirect_to(category_group_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe CategoryGroupsController, "handling PUT /category_groups/1" do

  before do
    @category_group = mock_model(CategoryGroup, :to_param => "1")
    CategoryGroup.stub!(:find).and_return(@category_group)
  end
  
  def put_with_successful_update
    @category_group.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @category_group.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the category_group requested" do
    CategoryGroup.should_receive(:find).with("1").and_return(@category_group)
    put_with_successful_update
  end

  it "should update the found category_group" do
    put_with_successful_update
    assigns(:category_group).should equal(@category_group)
  end

  it "should assign the found category_group for the view" do
    put_with_successful_update
    assigns(:category_group).should equal(@category_group)
  end

  it "should redirect to the category_group on successful update" do
    put_with_successful_update
    response.should redirect_to(category_group_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe CategoryGroupsController, "handling DELETE /category_groups/1" do

  before do
    @category_group = mock_model(CategoryGroup, :destroy => true)
    CategoryGroup.stub!(:find).and_return(@category_group)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the category_group requested" do
    CategoryGroup.should_receive(:find).with("1").and_return(@category_group)
    do_delete
  end
  
  it "should call destroy on the found category_group" do
    @category_group.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the category_groups list" do
    do_delete
    response.should redirect_to(category_groups_url)
  end
end
