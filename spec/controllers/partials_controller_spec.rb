require File.dirname(__FILE__) + '/../spec_helper'

describe PartialsController do
  describe "handling GET /partials" do

    before(:each) do
      @partial = mock_model(Partial)
      Partial.stub!(:find).and_return([@partial])
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
  
    it "should find all partials" do
      Partial.should_receive(:find).with(:all).and_return([@partial])
      do_get
    end
  
    it "should assign the found partials for the view" do
      do_get
      assigns[:partials].should == [@partial]
    end
  end

  describe "handling GET /partials.xml" do

    before(:each) do
      @partial = mock_model(Partial, :to_xml => "XML")
      Partial.stub!(:find).and_return(@partial)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all partials" do
      Partial.should_receive(:find).with(:all).and_return([@partial])
      do_get
    end
  
    it "should render the found partials as xml" do
      @partial.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /partials/1" do

    before(:each) do
      @partial = mock_model(Partial)
      Partial.stub!(:find).and_return(@partial)
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
  
    it "should find the partial requested" do
      Partial.should_receive(:find).with("1").and_return(@partial)
      do_get
    end
  
    it "should assign the found partial for the view" do
      do_get
      assigns[:partial].should equal(@partial)
    end
  end

  describe "handling GET /partials/1.xml" do

    before(:each) do
      @partial = mock_model(Partial, :to_xml => "XML")
      Partial.stub!(:find).and_return(@partial)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the partial requested" do
      Partial.should_receive(:find).with("1").and_return(@partial)
      do_get
    end
  
    it "should render the found partial as xml" do
      @partial.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /partials/new" do

    before(:each) do
      @partial = mock_model(Partial)
      Partial.stub!(:new).and_return(@partial)
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
  
    it "should create an new partial" do
      Partial.should_receive(:new).and_return(@partial)
      do_get
    end
  
    it "should not save the new partial" do
      @partial.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new partial for the view" do
      do_get
      assigns[:partial].should equal(@partial)
    end
  end

  describe "handling GET /partials/1/edit" do

    before(:each) do
      @partial = mock_model(Partial)
      Partial.stub!(:find).and_return(@partial)
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
  
    it "should find the partial requested" do
      Partial.should_receive(:find).and_return(@partial)
      do_get
    end
  
    it "should assign the found Partial for the view" do
      do_get
      assigns[:partial].should equal(@partial)
    end
  end

  describe "handling POST /partials" do

    before(:each) do
      @partial = mock_model(Partial, :to_param => "1")
      Partial.stub!(:new).and_return(@partial)
    end
    
    describe "with successful save" do
  
      def do_post
        @partial.should_receive(:save).and_return(true)
        post :create, :partial => {}
      end
  
      it "should create a new partial" do
        Partial.should_receive(:new).with({}).and_return(@partial)
        do_post
      end

      it "should redirect to the new partial" do
        do_post
        response.should redirect_to(partial_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @partial.should_receive(:save).and_return(false)
        post :create, :partial => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /partials/1" do

    before(:each) do
      @partial = mock_model(Partial, :to_param => "1")
      Partial.stub!(:find).and_return(@partial)
    end
    
    describe "with successful update" do

      def do_put
        @partial.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the partial requested" do
        Partial.should_receive(:find).with("1").and_return(@partial)
        do_put
      end

      it "should update the found partial" do
        do_put
        assigns(:partial).should equal(@partial)
      end

      it "should assign the found partial for the view" do
        do_put
        assigns(:partial).should equal(@partial)
      end

      it "should redirect to the partial" do
        do_put
        response.should redirect_to(partial_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @partial.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /partials/1" do

    before(:each) do
      @partial = mock_model(Partial, :destroy => true)
      Partial.stub!(:find).and_return(@partial)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the partial requested" do
      Partial.should_receive(:find).with("1").and_return(@partial)
      do_delete
    end
  
    it "should call destroy on the found partial" do
      @partial.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the partials list" do
      do_delete
      response.should redirect_to(partials_url)
    end
  end
end