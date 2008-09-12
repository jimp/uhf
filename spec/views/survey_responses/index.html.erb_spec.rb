require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_responses/index.html.erb" do
  include SurveyResponsesHelper
  
  before(:each) do
    survey_response_98 = mock_model(SurveyResponse)
    survey_response_98.should_receive(:survey_id).and_return("1")
    survey_response_98.should_receive(:survey_option_id).and_return("1")
    survey_response_98.should_receive(:url).and_return("MyString")
    survey_response_98.should_receive(:other_text).and_return("MyString")
    survey_response_99 = mock_model(SurveyResponse)
    survey_response_99.should_receive(:survey_id).and_return("1")
    survey_response_99.should_receive(:survey_option_id).and_return("1")
    survey_response_99.should_receive(:url).and_return("MyString")
    survey_response_99.should_receive(:other_text).and_return("MyString")

    assigns[:survey_responses] = [survey_response_98, survey_response_99]
  end

  it "should render list of survey_responses" do
    render "/survey_responses/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

