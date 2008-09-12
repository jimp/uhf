require File.dirname(__FILE__) + '/../../spec_helper'

describe "/categories/new.html.erb" do
  include CategoriesHelper
  
  before(:each) do
    @category = mock_model(Category)
    @category.stub!(:new_record?).and_return(true)
    @category.stub!(:category_group_id).and_return("1")
    @category.stub!(:name).and_return("MyString")
    @category.stub!(:positions).and_return("1")
    assigns[:category] = @category
  end

  it "should render new form" do
    render "/categories/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", categories_path) do
      with_tag("input#category_name[name=?]", "category[name]")
      with_tag("input#category_positions[name=?]", "category[positions]")
    end
  end
end


