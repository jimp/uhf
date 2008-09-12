require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_responses/new.html.erb" do
  include SurveyResponsesHelper
  
  before(:each) do
    @survey_response = mock_model(SurveyResponse)
    @survey_response.stub!(:new_record?).and_return(true)
    @survey_response.stub!(:survey_id).and_return("1")
    @survey_response.stub!(:survey_option_id).and_return("1")
    @survey_response.stub!(:url).and_return("MyString")
    @survey_response.stub!(:other_text).and_return("MyString")
    assigns[:survey_response] = @survey_response
  end

  it "should render new form" do
    render "/survey_responses/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", survey_responses_path) do
      with_tag("input#survey_response_url[name=?]", "survey_response[url]")
      with_tag("input#survey_response_other_text[name=?]", "survey_response[other_text]")
    end
  end
end


