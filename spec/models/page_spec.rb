require File.dirname(__FILE__) + '/../spec_helper'

# http://www.railsenvy.com/2007/2/19/acts-as-ferret-tutorial

describe "acts_as_ferret" do
  fixtures :pages, :content_blocks
  before(:each) do
    Page.rebuild_index
  end
  it "should not find non-existant pages" do
    Page.find_by_contents("not in db").size.should == 0
  end
  it "should find existing pages by title" do
    Page.find_by_contents("people").size.should == 3
  end
  it "should paginate_search" do
    Page.paginate_search("people",{:page=>1}).size.should == 3
  end
  it "should touch" do
    Page.find(:first).touch.should == true
  end
end

describe "Given a generated page_spec.rb with fixtures loaded" do
  fixtures :pages

  it "fixtures should load fixtures" do
    Page.should have(5).records
  end
end

describe Page do
  fixtures :pages, :partials, :aliases

  before(:each) do
    @page=Page.new
  end
  #  it "should require a path" do
  #    @page.valid?
  #    @page.should have(1).errors_on(:path)
  #  end
  it "should strip whitespace from all parts" do
    @page.path=" this is a test "
    @page.valid?
    @page.path.should == "this_is_a_test"
  end
  it "should require a unique path with the same parent id" do
    @page.path = Page.find(:first).path
    @page.valid?
    @page.should have(1).errors_on(:path)
  end
  it "should allow letters, numbers, underscores, slashes and dashes" do
    @page.path="abc123-_asdf"
    @page.valid?
    @page.should have(0).errors_on(:path)
  end
  it "should not allow punctuation or other characters" do
    ["`", "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "+", "=", "{", "}", "[", "]", ":", ";", "'", '"', "<", ">", "?", "|","\\"].each do |sym|
      @page.path=sym
      @page.valid?
      #p "#{sym}=#{@page.errors.count}" unless @page.valid?
      @page.should have(1).errors_on(:path)
    end
  end
  it "should find existing routes" do
    Page.existing_routes.should be_kind_of(Array)
  end
  it "should check against existing routes for child" do
    @page.path="blog"
    @page.valid?
    @page.should have(1).errors_on(:path)
  end
  it "should have valid link text" do
    @page=Page.new
    @page.link_text.should == 'index'
    @page.path = 'about'
    @page.link_text.should == 'about'
    @page.link_text = 'changed'
    @page.link_text.should == 'changed'
  end
  it "should have valid css id" do
    @page=Page.new
    @page.css_identifier.should == 'index'
    @page.path = 'about'
    @page.css_identifier.should == 'about'
    @page.css_identifier = 'changed'
    @page.css_identifier.should == 'changed'
  end
  it "should belong to a template" do
    Page.find(:first).template.should be_kind_of(Partial)
  end
  it "should find_by_alias" do
    Page.find_by_alias('c1').should == Page.find(2)
    Page.find_by_alias('c1/c2').should == Page.find(3)
    Page.find_by_alias('/c1/c2/').should == Page.find(3)
    Page.find_by_alias('not in database').should be_nil
  end
  it "should delete aliases" do
    lambda{Alias.update}.should change(Alias, :count).by(-1) # => deletes the one not in the database
  end
  it "should delete dependent children and paths" do
    lambda{Page.find(4).destroy}.should change(Page, :count).by(-1) # => deletes the one not in the database
  end
  it "should delete dependent children and aliases" do
    lambda{Page.find(4).destroy}.should change(Alias, :count).by(-2) # => deletes the one not in the database
  end
  it "should exclude all children with all_non_children" do
    Page.find(2).all_non_children.length.should == 2
  end
  it "should register index properly" do
    Page.find(1).index?.should == true
    p = Page.find(2)
    p.index?.should==false
    p.update_attributes!(:path=>'index')
    p.index?.should==false
  end
  it "should get main_menu links properly" do
    Page.main_menu.size.should == 2
  end
  it "should get jump_menu links properly" do
    Page.jump_menu.size.should == 3
  end  
  it "should have all content_block text" do
    Page.find(:first).content_block_text.should == "Block One Block Two"
  end
end

describe Page, "at level zero" do
  fixtures :pages
  before(:each) do
    @page=Page.find(1)
  end
  it "should be at level 0" do
    @page.level.should == 0
  end
  it "should have a correct url" do
    @page.url.should=="/"
  end
  it "should have the correct nearest left sibling" do
    @page.nearest_sibling(:left).should be_nil
    Page.find(5).nearest_sibling(:left).should == @page
  end
  it "should have the correc nearest right sibling" do
    @page.nearest_sibling(:right).should == Page.find(5)
    Page.find(5).nearest_sibling(:right).should be_nil
  end
  it "should move right" do
    @page.move_right!
    Page.find(1).nearest_sibling(:right).should be_nil
    Page.find(5).nearest_sibling(:right).should == Page.find(1)
    @page.reload
    @page.move_left!
    @page.nearest_sibling(:right).should == Page.find(5)
    Page.find(5).nearest_sibling(:right).should be_nil
  end
end

describe Page, "at level one" do
  fixtures :pages
  before(:each) do
    @page=Page.find(2)
  end
  it "should be at level 1" do
    @page.level.should == 1
  end
  it "should have a correct url" do
    @page.url.should=="/c1/"
  end
  it "should have the correc nearest left sibling" do
    @page.nearest_sibling(:left).should be_nil
  end
  it "should have the correc nearest right sibling" do
    @page.nearest_sibling(:right).should be_nil
  end
end

describe Page, "at level two" do
  fixtures :pages
  before(:each) do
    @page=Page.find(3)
  end
  it "should be at level 2" do
    @page.level.should == 2
  end
  it "should have a correct url" do
    @page.url.should=="/c1/c2/"
  end
end