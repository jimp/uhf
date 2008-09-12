require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_responses/edit.html.erb" do
  include SurveyResponsesHelper
  
  before do
    @survey_response = mock_model(SurveyResponse)
    @survey_response.stub!(:survey_id).and_return("1")
    @survey_response.stub!(:survey_option_id).and_return("1")
    @survey_response.stub!(:url).and_return("MyString")
    @survey_response.stub!(:other_text).and_return("MyString")
    assigns[:survey_response] = @survey_response
  end

  it "should render edit form" do
    render "/survey_responses/edit.html.erb"
    
    response.should have_tag("form[action=#{survey_response_path(@survey_response)}][method=post]") do
      with_tag('input#survey_response_url[name=?]', "survey_response[url]")
      with_tag('input#survey_response_other_text[name=?]', "survey_response[other_text]")
    end
  end
end


