require File.dirname(__FILE__) + '/../spec_helper'

describe AliasesController, "#route_for" do

  it "should map { :controller => 'aliases', :action => 'index' } to /aliases" do
    route_for(:controller => "aliases", :action => "index").should == "/aliases"
  end
  
  it "should map { :controller => 'aliases', :action => 'new' } to /aliases/new" do
    route_for(:controller => "aliases", :action => "new").should == "/aliases/new"
  end
  
  it "should map { :controller => 'aliases', :action => 'show', :id => 1 } to /aliases/1" do
    route_for(:controller => "aliases", :action => "show", :id => 1).should == "/aliases/1"
  end
  
  it "should map { :controller => 'aliases', :action => 'edit', :id => 1 } to /aliases/1/edit" do
    route_for(:controller => "aliases", :action => "edit", :id => 1).should == "/aliases/1/edit"
  end
  
  it "should map { :controller => 'aliases', :action => 'update', :id => 1} to /aliases/1" do
    route_for(:controller => "aliases", :action => "update", :id => 1).should == "/aliases/1"
  end
  
  it "should map { :controller => 'aliases', :action => 'destroy', :id => 1} to /aliases/1" do
    route_for(:controller => "aliases", :action => "destroy", :id => 1).should == "/aliases/1"
  end
  
end

describe AliasesController, "handling GET /aliases" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias)
    Alias.stub!(:find).and_return([@alias])
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
  
  it "should find all aliases" do
    Alias.should_receive(:paginate).and_return([@array])
    do_get
  end
  
  it "should assign the found aliases for the view" do
    do_get
    assigns[:aliases].should == [@alias]
  end
end

describe AliasesController, "handling GET /aliases.xml" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias, :to_xml => "XML")
    Alias.stub!(:paginate).and_return(@alias)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all aliases" do
    #Alias.should_receive(:find).with(:all).and_return([@alias])
    do_get
  end
  
  it "should render the found aliases as xml" do
    @alias.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe AliasesController, "handling GET /aliases/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias)
    Alias.stub!(:find).and_return(@alias)
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
  
  it "should find the aka requested" do
    Alias.should_receive(:find).with("1").and_return(@alias)
    do_get
  end
  
  it "should assign the found aka for the view" do
    do_get
    assigns[:alias].should equal(@alias)
  end
end

describe AliasesController, "handling GET /aliases/1.xml" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias, :to_xml => "XML")
    Alias.stub!(:find).and_return(@alias)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the aka requested" do
    Alias.should_receive(:find).with("1").and_return(@alias)
    do_get
  end
  
  it "should render the found aka as xml" do
    @alias.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe AliasesController, "handling GET /aliases/new" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias)
    Alias.stub!(:new).and_return(@alias)
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
  
  it "should create an new aka" do
    Alias.should_receive(:new).and_return(@alias)
    do_get
  end
  
  it "should not save the new aka" do
    @alias.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new aka for the view" do
    do_get
    assigns[:alias].should equal(@alias)
  end
end

describe AliasesController, "handling GET /aliases/1/edit" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias)
    Alias.stub!(:find).and_return(@alias)
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
  
  it "should find the aka requested" do
    Alias.should_receive(:find).and_return(@alias)
    do_get
  end
  
  it "should assign the found Alias for the view" do
    do_get
    assigns[:alias].should equal(@alias)
  end
end

describe AliasesController, "handling POST /aliases" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias, :to_param => "1", :save => true)
    Alias.stub!(:new).and_return(@alias)
    @params = {}
  end
  
  def do_post
    post :create, :alias => @params
  end
  
  it "should create a new aka" do
    Alias.should_receive(:new).with(@params).and_return(@alias)
    do_post
  end

  it "should redirect to the new aka" do
    do_post
    response.should redirect_to(aliases_url)
  end
end

describe AliasesController, "handling PUT /aliases/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias, :to_param => "1", :update_attributes => true)
    Alias.stub!(:find).and_return(@alias)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the aka requested" do
    Alias.should_receive(:find).with("1").and_return(@alias)
    do_update
  end

  it "should update the found aka" do
    @alias.should_receive(:update_attributes)
    do_update
    assigns(:alias).should equal(@alias)
  end

  it "should assign the found aka for the view" do
    do_update
    assigns(:alias).should equal(@alias)
  end

  it "should redirect to the aka" do
    do_update
    response.should redirect_to(aliases_url)
  end
end

describe AliasesController, "handling DELETE /aliases/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @alias = mock_model(Alias, :destroy => true)
    Alias.stub!(:find).and_return(@alias)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the aka requested" do
    Alias.should_receive(:find).with("1").and_return(@alias)
    do_delete
  end
  
  it "should call destroy on the found aka" do
    @alias.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the aliases list" do
    do_delete
    response.should redirect_to(aliases_url)
  end
end
