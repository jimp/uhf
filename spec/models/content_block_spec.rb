require File.dirname(__FILE__) + '/../spec_helper'

describe ContentBlock do
  fixtures :pages, :content_blocks

  before(:each) do
    Page.rebuild_index
  end
  it "should belong to page" do
    ContentBlock.find(:first).blockable.should be_kind_of(Page)
  end
  it "should rebuild the page index after saving" do
    Page.find_by_contents("xavier").size.should==0
    ContentBlock.create!(:text=>'xavier', :blockable_id=>1, :blockable_type=>'Page')
    Page.find_by_contents("xavier").size.should==1
  end
end

describe "an individual block" do
  fixtures :pages, :content_blocks
  before(:each) do
    @block = ContentBlock.find(:first)
  end
  it "should belong to blockable" do
    @block.blockable.should be_kind_of(Page)
  end
end