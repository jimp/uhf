require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_questions/index.html.erb" do
  include SurveyQuestionsHelper
  
  before(:each) do
    survey_question_98 = mock_model(SurveyQuestion)
    survey_question_98.should_receive(:survey_id).and_return("1")
    survey_question_98.should_receive(:question).and_return("MyString")
    survey_question_98.should_receive(:position).and_return("1")
    survey_question_99 = mock_model(SurveyQuestion)
    survey_question_99.should_receive(:survey_id).and_return("1")
    survey_question_99.should_receive(:question).and_return("MyString")
    survey_question_99.should_receive(:position).and_return("1")

    assigns[:survey_questions] = [survey_question_98, survey_question_99]
  end

  it "should render list of survey_questions" do
    render "/survey_questions/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

