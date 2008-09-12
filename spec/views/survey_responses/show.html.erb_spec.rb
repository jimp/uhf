require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_responses/show.html.erb" do
  include SurveyResponsesHelper
  
  before(:each) do
    @survey_response = mock_model(SurveyResponse)
    @survey_response.stub!(:survey_id).and_return("1")
    @survey_response.stub!(:survey_option_id).and_return("1")
    @survey_response.stub!(:url).and_return("MyString")
    @survey_response.stub!(:other_text).and_return("MyString")

    assigns[:survey_response] = @survey_response
  end

  it "should render attributes in <p>" do
    render "/survey_responses/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

