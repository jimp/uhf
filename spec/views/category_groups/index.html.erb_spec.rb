require File.dirname(__FILE__) + '/../../spec_helper'

describe "/category_groups/index.html.erb" do
  include CategoryGroupsHelper
  
  before(:each) do
    category_group_98 = mock_model(CategoryGroup)
    category_group_98.should_receive(:name).and_return("MyString")
    category_group_98.should_receive(:positions).and_return("1")
    category_group_99 = mock_model(CategoryGroup)
    category_group_99.should_receive(:name).and_return("MyString")
    category_group_99.should_receive(:positions).and_return("1")

    assigns[:category_groups] = [category_group_98, category_group_99]
  end

  it "should render list of category_groups" do
    render "/category_groups/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

