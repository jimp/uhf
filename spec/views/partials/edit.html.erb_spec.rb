require File.dirname(__FILE__) + '/../../spec_helper'

describe "/partials/edit.html.erb" do
  include PartialsHelper
  
  before do
    @partial = mock_model(Partial)
    @partial.stub!(:name).and_return("MyString")
    @partial.stub!(:description).and_return("MyText")
    @partial.stub!(:thumbnail).and_return("MyString")
    @partial.stub!(:position).and_return("1")
    assigns[:partial] = @partial
  end

  it "should render edit form" do
    render "/partials/edit.html.erb"
    
    response.should have_tag("form[action=#{partial_path(@partial)}][method=post]") do
      with_tag('input#partial_name[name=?]', "partial[name]")
      with_tag('textarea#partial_description[name=?]', "partial[description]")
      with_tag('input#partial_thumbnail[name=?]', "partial[thumbnail]")
      with_tag('input#partial_position[name=?]', "partial[position]")
    end
  end
end


