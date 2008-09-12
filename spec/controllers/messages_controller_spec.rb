require File.dirname(__FILE__) + '/../spec_helper'

describe MessagesController, "#route_for" do

  it "should map { :controller => 'messages', :action => 'index' } to /messages" do
    route_for(:controller => "messages", :action => "index").should == "/messages"
  end
  
  it "should map { :controller => 'messages', :action => 'new' } to /messages/new" do
    route_for(:controller => "messages", :action => "new").should == "/messages/new"
  end
  
  it "should map { :controller => 'messages', :action => 'show', :id => 1 } to /messages/1" do
    route_for(:controller => "messages", :action => "show", :id => 1).should == "/messages/1"
  end
  
  it "should map { :controller => 'messages', :action => 'edit', :id => 1 } to /messages/1/edit" do
    route_for(:controller => "messages", :action => "edit", :id => 1).should == "/messages/1/edit"
  end
  
  it "should map { :controller => 'messages', :action => 'update', :id => 1} to /messages/1" do
    route_for(:controller => "messages", :action => "update", :id => 1).should == "/messages/1"
  end
  
  it "should map { :controller => 'messages', :action => 'destroy', :id => 1} to /messages/1" do
    route_for(:controller => "messages", :action => "destroy", :id => 1).should == "/messages/1"
  end
  
end

describe MessagesController, "handling GET /messages" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @message = mock_model(Message)
    Message.stub!(:paginate).and_return([@message])
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
  
  it "should find all messages" do
    do_get
  end
  
  it "should assign the found messages for the view" do
    do_get
    assigns[:messages].should == [@message]
  end
end

describe MessagesController, "handling GET /messages/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @message = mock_model(Message)
    Message.stub!(:find).and_return(@message)
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
  
  it "should find the message requested" do
    Message.should_receive(:find).with("1").and_return(@message)
    do_get
  end
  
  it "should assign the found message for the view" do
    do_get
    assigns[:message].should equal(@message)
  end
end

describe MessagesController, "handling GET /messages/new" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @message = mock_model(Message)
    Message.stub!(:new).and_return(@message)
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
  
  it "should create an new message" do
    Message.should_receive(:new).and_return(@message)
    do_get
  end
  
  it "should not save the new message" do
    @message.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new message for the view" do
    do_get
    assigns[:message].should equal(@message)
  end
end

describe MessagesController, "handling GET /messages/1/edit" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @message = mock_model(Message)
    Message.stub!(:find).and_return(@message)
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
  
  it "should find the message requested" do
    Message.should_receive(:find).and_return(@message)
    do_get
  end
  
  it "should assign the found Message for the view" do
    do_get
    assigns[:message].should equal(@message)
  end
end

describe MessagesController, "handling POST /messages" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @message = mock_model(Message, :to_param => "1", :save => true)
    Message.stub!(:new).and_return(@message)
    @params = {}
  end
  
  def do_post
    post :create, :message => @params
  end
  
  it "should create a new message" do
    Message.should_receive(:new).with(@params).and_return(@message)
    do_post
  end

  it "should redirect to the new message" do
    do_post
    response.should redirect_to(message_url("1"))
  end
end

describe MessagesController, "handling PUT /messages/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @message = mock_model(Message, :to_param => "1", :update_attributes => true)
    Message.stub!(:find).and_return(@message)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the message requested" do
    Message.should_receive(:find).with("1").and_return(@message)
    do_update
  end

  it "should update the found message" do
    @message.should_receive(:update_attributes)
    do_update
    assigns(:message).should equal(@message)
  end

  it "should assign the found message for the view" do
    do_update
    assigns(:message).should equal(@message)
  end

  it "should redirect to the message" do
    do_update
    response.should redirect_to(message_url("1"))
  end
end

describe MessagesController, "handling DELETE /messages/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @message = mock_model(Message, :destroy => true)
    Message.stub!(:find).and_return(@message)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the message requested" do
    Message.should_receive(:find).with("1").and_return(@message)
    do_delete
  end
  
  it "should call destroy on the found message" do
    @message.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the messages list" do
    do_delete
    response.should redirect_to(messages_url)
  end
end
