require File.dirname(__FILE__) + '/../../spec_helper'

describe "/category_groups/edit.html.erb" do
  include CategoryGroupsHelper
  
  before do
    @category_group = mock_model(CategoryGroup)
    @category_group.stub!(:name).and_return("MyString")
    @category_group.stub!(:positions).and_return("1")
    assigns[:category_group] = @category_group
  end

  it "should render edit form" do
    render "/category_groups/edit.html.erb"
    
    response.should have_tag("form[action=#{category_group_path(@category_group)}][method=post]") do
      with_tag('input#category_group_name[name=?]', "category_group[name]")
      with_tag('input#category_group_positions[name=?]', "category_group[positions]")
    end
  end
end


