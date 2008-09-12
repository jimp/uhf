require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyQuestion do
  before(:each) do
    @survey_question = SurveyQuestion.new
  end

  it "should be valid" do
    @survey_question.should be_valid
  end
end
