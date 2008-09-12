require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyResponse do
  before(:each) do
    @survey_response = SurveyResponse.new
  end

  it "should be valid" do
    @survey_response.should be_valid
  end
end
