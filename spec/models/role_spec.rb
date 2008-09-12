require File.dirname(__FILE__) + '/../spec_helper'

describe Role do
  fixtures :roles, :users
  
  before(:each) do
    @role = Role.new
  end
  
  it "should require a name" do
    @role.valid?
    @role.should have(1).errors_on(:name)
  end
  
  it "should require a unique name" do
    @role.name = Role.find(:first).name
    @role.valid?
    @role.should have(1).errors_on(:name)
  end
  
  it "should have many users" do
    @role.users.should be_kind_of(Array)
  end
end

