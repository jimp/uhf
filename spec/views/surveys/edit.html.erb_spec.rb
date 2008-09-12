require File.dirname(__FILE__) + '/../../spec_helper'

describe "/surveys/edit.html.erb" do
  include SurveysHelper
  
  before do
    @survey = mock_model(Survey)
    @survey.stub!(:name).and_return("MyString")
    assigns[:survey] = @survey
  end

  it "should render edit form" do
    render "/surveys/edit.html.erb"
    
    response.should have_tag("form[action=#{survey_path(@survey)}][method=post]") do
      with_tag('input#survey_name[name=?]', "survey[name]")
    end
  end
end


