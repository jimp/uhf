require File.dirname(__FILE__) + '/../../spec_helper'

describe "/survey_options/edit.html.erb" do
  include SurveyOptionsHelper
  
  before do
    @survey_option = mock_model(SurveyOption)
    @survey_option.stub!(:name).and_return("MyString")
    @survey_option.stub!(:survey_id).and_return("1")
    @survey_option.stub!(:position).and_return("1")
    assigns[:survey_option] = @survey_option
  end

  it "should render edit form" do
    render "/survey_options/edit.html.erb"
    
    response.should have_tag("form[action=#{survey_option_path(@survey_option)}][method=post]") do
      with_tag('input#survey_option_name[name=?]', "survey_option[name]")
      with_tag('input#survey_option_position[name=?]', "survey_option[position]")
    end
  end
end


