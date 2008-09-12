require File.dirname(__FILE__) + '/../../spec_helper'

describe "/partials/new.html.erb" do
  include PartialsHelper
  
  before(:each) do
    @partial = mock_model(Partial)
    @partial.stub!(:new_record?).and_return(true)
    @partial.stub!(:name).and_return("MyString")
    @partial.stub!(:description).and_return("MyText")
    @partial.stub!(:thumbnail).and_return("MyString")
    @partial.stub!(:position).and_return("1")
    assigns[:partial] = @partial
  end

  it "should render new form" do
    render "/partials/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", partials_path) do
      with_tag("input#partial_name[name=?]", "partial[name]")
      with_tag("textarea#partial_description[name=?]", "partial[description]")
      with_tag("input#partial_thumbnail[name=?]", "partial[thumbnail]")
      with_tag("input#partial_position[name=?]", "partial[position]")
    end
  end
end


