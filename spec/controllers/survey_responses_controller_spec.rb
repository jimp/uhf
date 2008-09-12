require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyResponsesController do
  describe "handling GET /survey_responses" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse)
      SurveyResponse.stub!(:find).and_return([@survey_response])
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
  
    it "should find all survey_responses" do
      SurveyResponse.should_receive(:find).with(:all).and_return([@survey_response])
      do_get
    end
  
    it "should assign the found survey_responses for the view" do
      do_get
      assigns[:survey_responses].should == [@survey_response]
    end
  end

  describe "handling GET /survey_responses.xml" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse, :to_xml => "XML")
      SurveyResponse.stub!(:find).and_return(@survey_response)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all survey_responses" do
      SurveyResponse.should_receive(:find).with(:all).and_return([@survey_response])
      do_get
    end
  
    it "should render the found survey_responses as xml" do
      @survey_response.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /survey_responses/1" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse)
      SurveyResponse.stub!(:find).and_return(@survey_response)
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
  
    it "should find the survey_response requested" do
      SurveyResponse.should_receive(:find).with("1").and_return(@survey_response)
      do_get
    end
  
    it "should assign the found survey_response for the view" do
      do_get
      assigns[:survey_response].should equal(@survey_response)
    end
  end

  describe "handling GET /survey_responses/1.xml" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse, :to_xml => "XML")
      SurveyResponse.stub!(:find).and_return(@survey_response)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the survey_response requested" do
      SurveyResponse.should_receive(:find).with("1").and_return(@survey_response)
      do_get
    end
  
    it "should render the found survey_response as xml" do
      @survey_response.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /survey_responses/new" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse)
      SurveyResponse.stub!(:new).and_return(@survey_response)
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
  
    it "should create an new survey_response" do
      SurveyResponse.should_receive(:new).and_return(@survey_response)
      do_get
    end
  
    it "should not save the new survey_response" do
      @survey_response.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new survey_response for the view" do
      do_get
      assigns[:survey_response].should equal(@survey_response)
    end
  end

  describe "handling GET /survey_responses/1/edit" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse)
      SurveyResponse.stub!(:find).and_return(@survey_response)
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
  
    it "should find the survey_response requested" do
      SurveyResponse.should_receive(:find).and_return(@survey_response)
      do_get
    end
  
    it "should assign the found SurveyResponse for the view" do
      do_get
      assigns[:survey_response].should equal(@survey_response)
    end
  end

  describe "handling POST /survey_responses" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse, :to_param => "1")
      SurveyResponse.stub!(:new).and_return(@survey_response)
    end
    
    describe "with successful save" do
  
      def do_post
        @survey_response.should_receive(:save).and_return(true)
        post :create, :survey_response => {}
      end
  
      it "should create a new survey_response" do
        SurveyResponse.should_receive(:new).with({}).and_return(@survey_response)
        do_post
      end

      it "should redirect to the new survey_response" do
        do_post
        response.should redirect_to(survey_response_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @survey_response.should_receive(:save).and_return(false)
        post :create, :survey_response => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /survey_responses/1" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse, :to_param => "1")
      SurveyResponse.stub!(:find).and_return(@survey_response)
    end
    
    describe "with successful update" do

      def do_put
        @survey_response.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the survey_response requested" do
        SurveyResponse.should_receive(:find).with("1").and_return(@survey_response)
        do_put
      end

      it "should update the found survey_response" do
        do_put
        assigns(:survey_response).should equal(@survey_response)
      end

      it "should assign the found survey_response for the view" do
        do_put
        assigns(:survey_response).should equal(@survey_response)
      end

      it "should redirect to the survey_response" do
        do_put
        response.should redirect_to(survey_response_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @survey_response.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /survey_responses/1" do

    before(:each) do
      @survey_response = mock_model(SurveyResponse, :destroy => true)
      SurveyResponse.stub!(:find).and_return(@survey_response)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the survey_response requested" do
      SurveyResponse.should_receive(:find).with("1").and_return(@survey_response)
      do_delete
    end
  
    it "should call destroy on the found survey_response" do
      @survey_response.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the survey_responses list" do
      do_delete
      response.should redirect_to(survey_responses_url)
    end
  end
end