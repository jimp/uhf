require File.dirname(__FILE__) + '/../../spec_helper'

describe "/categories/show.html.erb" do
  include CategoriesHelper
  
  before(:each) do
    @category = mock_model(Category)
    @category.stub!(:category_group_id).and_return("1")
    @category.stub!(:name).and_return("MyString")
    @category.stub!(:positions).and_return("1")

    assigns[:category] = @category
  end

  it "should render attributes in <p>" do
    render "/categories/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/1/)
  end
end

