require File.dirname(__FILE__) + '/../spec_helper'

describe Alias do
  fixtures :pages, :aliases

  before(:each) do
    @alias = Alias.new
  end
  it "should require a unique path" do
    @alias.name = Alias.find(:first).name
    @alias.valid?
    @alias.should have(1).errors_on(:name)
  end
  it "should belong to page" do
    Alias.find(:first).page.should == Page.find(:first)
  end
  it "should have path_with_slashes" do
    @alias.name="about"
    @alias.url.should == "/about"
    @alias.name='/'
    @alias.url.should == "/"
  end
  it "should strip slashes before validating" do
    @alias.name='/about/'
    @alias.valid?
    @alias.name.should == 'about'
  end
  it "should not strip slashes before validating on '/'" do
    @alias.name='/'
    @alias.valid?
    @alias.name.should == '/'
  end
end

describe Alias, "update" do
  fixtures :pages
  before(:each) do
    Alias.delete_all
  end
  it "should add records to the aliases table" do
    lambda{Alias.update}.should change(Alias,:count).by(Page.count)
  end
  it "should add correct paths" do
    Alias.update
    Alias.find(:first).name.should=='/'
  end
  it "should have many paths" do
    Page.find(:first).aliases.should be_kind_of(Array)
  end
  it "should find_by_path" do
    Alias.update
    Page.find_by_alias('/c1/').should == Page.find(2)
    Page.find_by_alias('/c1/c2').should == Page.find(3)
  end
  it "should find the index page by path as well" do
    Alias.update
    Page.find_by_alias('/index/').should == Page.find(1)
  end
  it "should update_paths after save" do
    lambda{Page.find(:first).update_attributes(:path=>'test')}.should change(Alias,:count).by(Page.count)
  end
  it "should return the count of affected records" do
    Alias.update.should == 5
  end
end
