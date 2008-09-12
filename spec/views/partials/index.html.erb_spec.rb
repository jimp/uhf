require File.dirname(__FILE__) + '/../../spec_helper'

describe "/partials/index.html.erb" do
  include PartialsHelper
  
  before(:each) do
    partial_98 = mock_model(Partial)
    partial_98.should_receive(:name).and_return("MyString")
    partial_98.should_receive(:description).and_return("MyText")
    partial_98.should_receive(:thumbnail).and_return("MyString")
    partial_98.should_receive(:position).and_return("1")
    partial_99 = mock_model(Partial)
    partial_99.should_receive(:name).and_return("MyString")
    partial_99.should_receive(:description).and_return("MyText")
    partial_99.should_receive(:thumbnail).and_return("MyString")
    partial_99.should_receive(:position).and_return("1")

    assigns[:partials] = [partial_98, partial_99]
  end

  it "should render list of partials" do
    render "/partials/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

