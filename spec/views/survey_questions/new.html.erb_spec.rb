require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_questions/new.html.erb" do
  include SurveyQuestionsHelper
  
  before(:each) do
    @survey_question = mock_model(SurveyQuestion)
    @survey_question.stub!(:new_record?).and_return(true)
    @survey_question.stub!(:survey_id).and_return("1")
    @survey_question.stub!(:question).and_return("MyString")
    @survey_question.stub!(:position).and_return("1")
    assigns[:survey_question] = @survey_question
  end

  it "should render new form" do
    render "/survey_questions/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", survey_questions_path) do
      with_tag("input#survey_question_question[name=?]", "survey_question[question]")
      with_tag("input#survey_question_position[name=?]", "survey_question[position]")
    end
  end
end


