require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController, "#route_for" do

  it "should map { :controller => 'events', :action => 'index' } to /events" do
    route_for(:controller => "events", :action => "index").should == "/events"
  end
  
  it "should map { :controller => 'events', :action => 'new' } to /events/new" do
    route_for(:controller => "events", :action => "new").should == "/events/new"
  end
  
  it "should map { :controller => 'events', :action => 'show', :id => 1 } to /events/1" do
    route_for(:controller => "events", :action => "show", :id => 1).should == "/events/1"
  end
  
  it "should map { :controller => 'events', :action => 'edit', :id => 1 } to /events/1/edit" do
    route_for(:controller => "events", :action => "edit", :id => 1).should == "/events/1/edit"
  end
  
  it "should map { :controller => 'events', :action => 'update', :id => 1} to /events/1" do
    route_for(:controller => "events", :action => "update", :id => 1).should == "/events/1"
  end
  
  it "should map { :controller => 'events', :action => 'destroy', :id => 1} to /events/1" do
    route_for(:controller => "events", :action => "destroy", :id => 1).should == "/events/1"
  end
  
end

describe EventsController, "handling GET /events" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event)
    Event.stub!(:find).and_return([@event])
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
  
  it "should find all events" do
    Event.should_receive(:find).with(:all).and_return([@event])
    do_get
  end
  
  it "should assign the found events for the view" do
    do_get
    assigns[:events].should == [@event]
  end
end

describe EventsController, "handling GET /events.xml" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event, :to_xml => "XML")
    Event.stub!(:find).and_return(@event)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all events" do
    Event.should_receive(:find).with(:all).and_return([@event])
    do_get
  end
  
  it "should render the found events as xml" do
    @event.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe EventsController, "handling GET /events/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event)
    Event.stub!(:find).and_return(@event)
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
  
  it "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_get
  end
  
  it "should assign the found event for the view" do
    do_get
    assigns[:event].should equal(@event)
  end
end

describe EventsController, "handling GET /events/1.xml" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event, :to_xml => "XML")
    Event.stub!(:find).and_return(@event)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_get
  end
  
  it "should render the found event as xml" do
    @event.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe EventsController, "handling GET /events/new" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event)
    Event.stub!(:new).and_return(@event)
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
  
  it "should create an new event" do
    Event.should_receive(:new).and_return(@event)
    do_get
  end
  
  it "should not save the new event" do
    @event.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new event for the view" do
    do_get
    assigns[:event].should equal(@event)
  end
end

describe EventsController, "handling GET /events/1/edit" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event)
    Event.stub!(:find).and_return(@event)
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
  
  it "should find the event requested" do
    Event.should_receive(:find).and_return(@event)
    do_get
  end
  
  it "should assign the found Event for the view" do
    do_get
    assigns[:event].should equal(@event)
  end
end

describe EventsController, "handling POST /events" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event, :to_param => "1", :save => true)
    Event.stub!(:new).and_return(@event)
    @params = {}
  end
  
  def do_post
    post :create, :event => @params
  end
  
  it "should create a new event" do
    Event.should_receive(:new).with(@params).and_return(@event)
    do_post
  end

  it "should redirect to the new event" do
    do_post
    response.should redirect_to(event_url("1"))
  end
end

describe EventsController, "handling PUT /events/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event, :to_param => "1", :update_attributes => true)
    Event.stub!(:find).and_return(@event)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_update
  end

  it "should update the found event" do
    @event.should_receive(:update_attributes)
    do_update
    assigns(:event).should equal(@event)
  end

  it "should assign the found event for the view" do
    do_update
    assigns(:event).should equal(@event)
  end

  it "should redirect to the event" do
    do_update
    response.should redirect_to(event_url("1"))
  end
end

describe EventsController, "handling DELETE /events/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @event = mock_model(Event, :destroy => true)
    Event.stub!(:find).and_return(@event)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_delete
  end
  
  it "should call destroy on the found event" do
    @event.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the events list" do
    do_delete
    response.should redirect_to(events_url)
  end
end
