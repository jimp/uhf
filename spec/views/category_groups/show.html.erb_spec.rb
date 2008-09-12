require File.dirname(__FILE__) + '/../../spec_helper'

describe "/category_groups/show.html.erb" do
  include CategoryGroupsHelper
  
  before(:each) do
    @category_group = mock_model(CategoryGroup)
    @category_group.stub!(:name).and_return("MyString")
    @category_group.stub!(:positions).and_return("1")

    assigns[:category_group] = @category_group
  end

  it "should render attributes in <p>" do
    render "/category_groups/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/1/)
  end
end

