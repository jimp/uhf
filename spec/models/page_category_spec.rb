require File.dirname(__FILE__) + '/../spec_helper'

describe PageCategory do
  before(:each) do
    @page_category = PageCategory.new
  end

  it "should be valid" do
    @page_category.should be_valid
  end
end
