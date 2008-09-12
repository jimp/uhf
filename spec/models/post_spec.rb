require File.dirname(__FILE__) + '/../spec_helper'

describe "acts_as_ferret" do
  fixtures :posts, :comments
  before(:each) do
    Post.rebuild_index
  end
  it "should not find non-existant pages" do
    Post.find_by_contents("not in db").size.should == 0
  end
  it "should find existing posts by title or body" do
    Post.find_by_contents("viagra").size.should == 2
  end
  it "should paginate_search" do
    Post.paginate_search("viagra",{:page=>1}).size.should == 2
  end
  it "should touch" do
    Post.find(:first).touch.should == true
  end
end

describe Post do
  fixtures :posts, :comments
  it "should have a list of published post" do
    Post.published.size.should == 5
  end
  it "should return a single published post with an id param" do
    Post.published(1).should == Post.find(:first)
  end
  it "should return nil if the id param belongs to an unpublished post" do
    Post.published(2).should be_nil
  end
  it "should have only published blogs in the list" do
    Post.published.each do |post|
      post.published_at?.should_not be_nil
    end
  end
  it "should find_by_date with year, month and day" do
    Post.find_by_date('2007','08','21').should have(2).records
  end
  it "should find_by_date with year and month" do
    Post.find_by_date('2007','08').should have(3).records
  end
  it "should find_by_date with year" do
    Post.find_by_date('2007').should have(4).records
  end
  it "should find_by_date with no params" do
    Post.find_by_date.should have(5).records
  end
end

describe "A new Post" do
  fixtures :posts, :comments
  before(:each) do
    @post = Post.new
  end
  it "should require a title" do
    @post.valid?
    @post.should have(1).errors_on(:title)
  end
  it "should require a unique title" do
    @post.title=Post.find(:first).title
    @post.valid?
    @post.should have(1).errors_on(:title)
  end
  it "should require a body" do
    @post.valid?
    @post.should have(1).errors_on(:body)
  end
  it "should have many comments" do
    @post.comments.should be_kind_of(Array)
  end
  it "should have approved comments" do
    @post.approved_comments.should be_kind_of(Array)
  end
  it "should have a correct year" do
    @post.year.should == ""
    @post.published_at = "2007-08-02"
    @post.year.should == "2007"
  end
  it "should have a correct month" do
    @post.month.should == ""
    @post.published_at = "2007-08-02"
    @post.month.should == "08"
  end
  it "should have a correct month_name" do
    @post.month_name.should == ""
    @post.published_at = "2007-08-07"
    @post.month_name.should == "August"
  end
  it "should have a correct day" do
    @post.day.should == ""
    @post.published_at = "2007-08-02"
    @post.day.should == "02"
  end
  it "should have a correct day_name" do
    @post.day_name.should == ""
    @post.published_at = "2007-08-02"
    @post.day_name.should == "Thursday"
  end
  it "should have a pretty date" do
    @post.pretty_date.should == ""
    @post.published_at = '2007-08-22'
    @post.pretty_date.should == 'Wednesday, August 22, 2007'
  end
  it "should have a pretty time" do
    @post.pretty_time.should == ""
    @post.published_at = '2007-08-22 08:30 AM'
    @post.pretty_time.should == '8:30 AM'
    @post.published_at = '2007-08-22 10:30 AM'
    @post.pretty_time.should == '10:30 AM'
  end
  it "should not have a url if it's new" do
    @post.url.should == ""
    @post.published_at = Time.now
    @post.url.should == ""
  end
  it "should not have a url" do
    Post.find(2).url.should == ""
  end
  it "should not have an archive_url" do
    @post.archive_url.should == ""
    @post.published_at = Time.now
    @post.archive_url.should == ""
  end
  it "should have a publish_on_save attribute" do
    @post.publish.should be_nil
    @post.publish=true
    @post.publish.should be_true
  end
  it "should save the published date if publish is true" do
    @post.publish = true
    @post.body='something'
    @post.title='something'
    @post.save.should be_true
    @post.published_at.should_not be_nil
  end
  it "should assign from the hash" do
    Post.new(:publish=>true).publish.should==true
  end
end

describe "Existing Individual Posts" do
  fixtures :posts, :comments
  before(:each) do
    @post = Post.new
  end
  it "should have a full url" do
    Post.find(:first).url.should=="/blog/2007/08/21/1"
  end
  it "should have a full atom url" do
    Post.find(:first).url(true).should=="/blog/2007/08/21/1.atom"
  end
  it "should unpublish on save if marked" do
    @post=Post.find(:first)
    @post.publish=false
    @post.save.should be_true
    @post.published_at.should be_nil
  end
  it "should stay published if unmarked" do
    @post=Post.find(:first)
    @post.body="changed"
    @post.save.should be_true
    @post.published_at.should_not be_nil
  end
  it "should have comments_open?" do
    @post.comments_open?.should be_true
    @post.comments_expire_at=2.days.from_now
    @post.comments_open?.should be_true
    @post.comments_expire_at=2.days.ago
    @post.comments_open?.should be_false
  end
  it "should have all_comments_text" do
    Post.find(:first).all_comments_text.should =~ /Lorem.+Lorem.+Viagra/
  end
end

describe "Existing Archived Posts" do
  fixtures :posts, :comments
  before(:each) do
    @post = Post.new
  end
  it "should have accurate years" do
    Post.archives.map(&:year).should==['2007','2007','2006']
  end
  it "should have accurate months" do
    Post.archives.map(&:month).should==['07','08','07']
  end
  it "should have accurate month_names" do
    Post.archives.map(&:month_name).should==['July','August','July']
  end
  it "should have accurate archive_urls" do
    Post.archives.map(&:archive_url).should==['/blog/2007/07/','/blog/2007/08/','/blog/2006/07/']
  end
  it "should have an archive url" do
    Post.find(:first).archive_url.should=="/blog/2007/08/"
  end
  it "should have an archive url with atom" do
    Post.find(:first).archive_url(true).should=="/blog/2007/08.atom"
  end
  it "should not have an archive url if it has no published_at date" do
    Post.find(2).archive_url.should == ""
  end
end
