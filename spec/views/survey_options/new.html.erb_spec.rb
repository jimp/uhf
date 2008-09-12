require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_options/new.html.erb" do
  include SurveyOptionsHelper
  
  before(:each) do
    @survey_option = mock_model(SurveyOption)
    @survey_option.stub!(:new_record?).and_return(true)
    @survey_option.stub!(:name).and_return("MyString")
    @survey_option.stub!(:survey_id).and_return("1")
    @survey_option.stub!(:position).and_return("1")
    assigns[:survey_option] = @survey_option
  end

  it "should render new form" do
    render "/survey_options/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", survey_options_path) do
      with_tag("input#survey_option_name[name=?]", "survey_option[name]")
      with_tag("input#survey_option_position[name=?]", "survey_option[position]")
    end
  end
end


