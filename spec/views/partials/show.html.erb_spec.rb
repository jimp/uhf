require File.dirname(__FILE__) + '/../../spec_helper'

describe "/partials/show.html.erb" do
  include PartialsHelper
  
  before(:each) do
    @partial = mock_model(Partial)
    @partial.stub!(:name).and_return("MyString")
    @partial.stub!(:description).and_return("MyText")
    @partial.stub!(:thumbnail).and_return("MyString")
    @partial.stub!(:position).and_return("1")

    assigns[:partial] = @partial
  end

  it "should render attributes in <p>" do
    render "/partials/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/MyString/)
    response.should have_text(/1/)
  end
end

