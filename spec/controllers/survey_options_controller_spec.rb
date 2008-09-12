require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyOptionsController do
  describe "handling GET /survey_options" do

    before(:each) do
      @survey_option = mock_model(SurveyOption)
      SurveyOption.stub!(:find).and_return([@survey_option])
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
  
    it "should find all survey_options" do
      SurveyOption.should_receive(:find).with(:all).and_return([@survey_option])
      do_get
    end
  
    it "should assign the found survey_options for the view" do
      do_get
      assigns[:survey_options].should == [@survey_option]
    end
  end

  describe "handling GET /survey_options.xml" do

    before(:each) do
      @survey_option = mock_model(SurveyOption, :to_xml => "XML")
      SurveyOption.stub!(:find).and_return(@survey_option)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all survey_options" do
      SurveyOption.should_receive(:find).with(:all).and_return([@survey_option])
      do_get
    end
  
    it "should render the found survey_options as xml" do
      @survey_option.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /survey_options/1" do

    before(:each) do
      @survey_option = mock_model(SurveyOption)
      SurveyOption.stub!(:find).and_return(@survey_option)
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
  
    it "should find the survey_option requested" do
      SurveyOption.should_receive(:find).with("1").and_return(@survey_option)
      do_get
    end
  
    it "should assign the found survey_option for the view" do
      do_get
      assigns[:survey_option].should equal(@survey_option)
    end
  end

  describe "handling GET /survey_options/1.xml" do

    before(:each) do
      @survey_option = mock_model(SurveyOption, :to_xml => "XML")
      SurveyOption.stub!(:find).and_return(@survey_option)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the survey_option requested" do
      SurveyOption.should_receive(:find).with("1").and_return(@survey_option)
      do_get
    end
  
    it "should render the found survey_option as xml" do
      @survey_option.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /survey_options/new" do

    before(:each) do
      @survey_option = mock_model(SurveyOption)
      SurveyOption.stub!(:new).and_return(@survey_option)
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
  
    it "should create an new survey_option" do
      SurveyOption.should_receive(:new).and_return(@survey_option)
      do_get
    end
  
    it "should not save the new survey_option" do
      @survey_option.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new survey_option for the view" do
      do_get
      assigns[:survey_option].should equal(@survey_option)
    end
  end

  describe "handling GET /survey_options/1/edit" do

    before(:each) do
      @survey_option = mock_model(SurveyOption)
      SurveyOption.stub!(:find).and_return(@survey_option)
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
  
    it "should find the survey_option requested" do
      SurveyOption.should_receive(:find).and_return(@survey_option)
      do_get
    end
  
    it "should assign the found SurveyOption for the view" do
      do_get
      assigns[:survey_option].should equal(@survey_option)
    end
  end

  describe "handling POST /survey_options" do

    before(:each) do
      @survey_option = mock_model(SurveyOption, :to_param => "1")
      SurveyOption.stub!(:new).and_return(@survey_option)
    end
    
    describe "with successful save" do
  
      def do_post
        @survey_option.should_receive(:save).and_return(true)
        post :create, :survey_option => {}
      end
  
      it "should create a new survey_option" do
        SurveyOption.should_receive(:new).with({}).and_return(@survey_option)
        do_post
      end

      it "should redirect to the new survey_option" do
        do_post
        response.should redirect_to(survey_option_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @survey_option.should_receive(:save).and_return(false)
        post :create, :survey_option => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /survey_options/1" do

    before(:each) do
      @survey_option = mock_model(SurveyOption, :to_param => "1")
      SurveyOption.stub!(:find).and_return(@survey_option)
    end
    
    describe "with successful update" do

      def do_put
        @survey_option.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the survey_option requested" do
        SurveyOption.should_receive(:find).with("1").and_return(@survey_option)
        do_put
      end

      it "should update the found survey_option" do
        do_put
        assigns(:survey_option).should equal(@survey_option)
      end

      it "should assign the found survey_option for the view" do
        do_put
        assigns(:survey_option).should equal(@survey_option)
      end

      it "should redirect to the survey_option" do
        do_put
        response.should redirect_to(survey_option_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @survey_option.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /survey_options/1" do

    before(:each) do
      @survey_option = mock_model(SurveyOption, :destroy => true)
      SurveyOption.stub!(:find).and_return(@survey_option)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the survey_option requested" do
      SurveyOption.should_receive(:find).with("1").and_return(@survey_option)
      do_delete
    end
  
    it "should call destroy on the found survey_option" do
      @survey_option.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the survey_options list" do
      do_delete
      response.should redirect_to(survey_options_url)
    end
  end
end