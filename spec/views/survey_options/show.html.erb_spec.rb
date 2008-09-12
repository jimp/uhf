require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_options/show.html.erb" do
  include SurveyOptionsHelper
  
  before(:each) do
    @survey_option = mock_model(SurveyOption)
    @survey_option.stub!(:name).and_return("MyString")
    @survey_option.stub!(:survey_id).and_return("1")
    @survey_option.stub!(:position).and_return("1")

    assigns[:survey_option] = @survey_option
  end

  it "should render attributes in <p>" do
    render "/survey_options/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/1/)
  end
end

