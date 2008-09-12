require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyQuestionsController do
  describe "handling GET /survey_questions" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion)
      SurveyQuestion.stub!(:find).and_return([@survey_question])
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
  
    it "should find all survey_questions" do
      SurveyQuestion.should_receive(:find).with(:all).and_return([@survey_question])
      do_get
    end
  
    it "should assign the found survey_questions for the view" do
      do_get
      assigns[:survey_questions].should == [@survey_question]
    end
  end

  describe "handling GET /survey_questions.xml" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion, :to_xml => "XML")
      SurveyQuestion.stub!(:find).and_return(@survey_question)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all survey_questions" do
      SurveyQuestion.should_receive(:find).with(:all).and_return([@survey_question])
      do_get
    end
  
    it "should render the found survey_questions as xml" do
      @survey_question.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /survey_questions/1" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion)
      SurveyQuestion.stub!(:find).and_return(@survey_question)
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
  
    it "should find the survey_question requested" do
      SurveyQuestion.should_receive(:find).with("1").and_return(@survey_question)
      do_get
    end
  
    it "should assign the found survey_question for the view" do
      do_get
      assigns[:survey_question].should equal(@survey_question)
    end
  end

  describe "handling GET /survey_questions/1.xml" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion, :to_xml => "XML")
      SurveyQuestion.stub!(:find).and_return(@survey_question)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the survey_question requested" do
      SurveyQuestion.should_receive(:find).with("1").and_return(@survey_question)
      do_get
    end
  
    it "should render the found survey_question as xml" do
      @survey_question.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /survey_questions/new" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion)
      SurveyQuestion.stub!(:new).and_return(@survey_question)
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
  
    it "should create an new survey_question" do
      SurveyQuestion.should_receive(:new).and_return(@survey_question)
      do_get
    end
  
    it "should not save the new survey_question" do
      @survey_question.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new survey_question for the view" do
      do_get
      assigns[:survey_question].should equal(@survey_question)
    end
  end

  describe "handling GET /survey_questions/1/edit" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion)
      SurveyQuestion.stub!(:find).and_return(@survey_question)
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
  
    it "should find the survey_question requested" do
      SurveyQuestion.should_receive(:find).and_return(@survey_question)
      do_get
    end
  
    it "should assign the found SurveyQuestion for the view" do
      do_get
      assigns[:survey_question].should equal(@survey_question)
    end
  end

  describe "handling POST /survey_questions" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion, :to_param => "1")
      SurveyQuestion.stub!(:new).and_return(@survey_question)
    end
    
    describe "with successful save" do
  
      def do_post
        @survey_question.should_receive(:save).and_return(true)
        post :create, :survey_question => {}
      end
  
      it "should create a new survey_question" do
        SurveyQuestion.should_receive(:new).with({}).and_return(@survey_question)
        do_post
      end

      it "should redirect to the new survey_question" do
        do_post
        response.should redirect_to(survey_question_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @survey_question.should_receive(:save).and_return(false)
        post :create, :survey_question => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /survey_questions/1" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion, :to_param => "1")
      SurveyQuestion.stub!(:find).and_return(@survey_question)
    end
    
    describe "with successful update" do

      def do_put
        @survey_question.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the survey_question requested" do
        SurveyQuestion.should_receive(:find).with("1").and_return(@survey_question)
        do_put
      end

      it "should update the found survey_question" do
        do_put
        assigns(:survey_question).should equal(@survey_question)
      end

      it "should assign the found survey_question for the view" do
        do_put
        assigns(:survey_question).should equal(@survey_question)
      end

      it "should redirect to the survey_question" do
        do_put
        response.should redirect_to(survey_question_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @survey_question.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /survey_questions/1" do

    before(:each) do
      @survey_question = mock_model(SurveyQuestion, :destroy => true)
      SurveyQuestion.stub!(:find).and_return(@survey_question)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the survey_question requested" do
      SurveyQuestion.should_receive(:find).with("1").and_return(@survey_question)
      do_delete
    end
  
    it "should call destroy on the found survey_question" do
      @survey_question.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the survey_questions list" do
      do_delete
      response.should redirect_to(survey_questions_url)
    end
  end
end