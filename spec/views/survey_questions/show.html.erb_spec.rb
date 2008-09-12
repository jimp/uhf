require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_questions/show.html.erb" do
  include SurveyQuestionsHelper
  
  before(:each) do
    @survey_question = mock_model(SurveyQuestion)
    @survey_question.stub!(:survey_id).and_return("1")
    @survey_question.stub!(:question).and_return("MyString")
    @survey_question.stub!(:position).and_return("1")

    assigns[:survey_question] = @survey_question
  end

  it "should render attributes in <p>" do
    render "/survey_questions/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/1/)
  end
end

