require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_questions/edit.html.erb" do
  include SurveyQuestionsHelper
  
  before do
    @survey_question = mock_model(SurveyQuestion)
    @survey_question.stub!(:survey_id).and_return("1")
    @survey_question.stub!(:question).and_return("MyString")
    @survey_question.stub!(:position).and_return("1")
    assigns[:survey_question] = @survey_question
  end

  it "should render edit form" do
    render "/survey_questions/edit.html.erb"
    
    response.should have_tag("form[action=#{survey_question_path(@survey_question)}][method=post]") do
      with_tag('input#survey_question_question[name=?]', "survey_question[question]")
      with_tag('input#survey_question_position[name=?]', "survey_question[position]")
    end
  end
end


