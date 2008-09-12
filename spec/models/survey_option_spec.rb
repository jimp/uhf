require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyOption do
  before(:each) do
    @survey_option = SurveyOption.new
  end

  it "should be valid" do
    @survey_option.should be_valid
  end
end
