require File.dirname(__FILE__) + '/../spec_helper'

describe CategoryGroup do
  before(:each) do
    @category_group = CategoryGroup.new
  end

  it "should be valid" do
    @category_group.should be_valid
  end
end
