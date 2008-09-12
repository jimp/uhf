require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_options/index.html.erb" do
  include SurveyOptionsHelper
  
  before(:each) do
    survey_option_98 = mock_model(SurveyOption)
    survey_option_98.should_receive(:name).and_return("MyString")
    survey_option_98.should_receive(:survey_id).and_return("1")
    survey_option_98.should_receive(:position).and_return("1")
    survey_option_99 = mock_model(SurveyOption)
    survey_option_99.should_receive(:name).and_return("MyString")
    survey_option_99.should_receive(:survey_id).and_return("1")
    survey_option_99.should_receive(:position).and_return("1")

    assigns[:survey_options] = [survey_option_98, survey_option_99]
  end

  it "should render list of survey_options" do
    render "/survey_options/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

