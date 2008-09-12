require File.dirname(__FILE__) + '/../spec_helper'

describe Partial do
  fixtures :partials
  before(:each) do
    @partial = Partial.new
  end
  it "should have a default" do
    Partial.default.should == Partial.find(:first)
  end
  it "should create a default" do
    Partial.delete_all
    Partial.default.should be_kind_of(Partial)
  end
  it "should create a new row" do
    Partial.delete_all
    lambda{Partial.default}.should change(Partial,:count).by(1)
  end
end
