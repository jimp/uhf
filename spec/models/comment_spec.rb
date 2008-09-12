require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  fixtures :posts, :comments
  before(:each) do
    @comment = Comment.new
  end
  it "should belong to post" do
    Comment.find(:first).commentable.should be_kind_of(Post)
  end
  it "should require a commentable" do
    @comment.valid?
    @comment.should have(1).errors_on(:commentable_id)
    @comment.should have(1).errors_on(:commentable_type)
  end
  it "should require a name" do
    @comment.valid?
    @comment.should have(1).errors_on(:name)
  end  
  it "should require a body" do
    @comment.valid?
    @comment.should have(1).errors_on(:body)
  end  
  it "should require an email" do
    @comment.valid?
    @comment.should have(1).errors_on(:email)
  end
  it "should be able to find_approved" do
    Comment.approved.length.should == 1
    Comment.approved(1).length.should == 1
  end
  it "should only have approved comments in the approved list" do
    Comment.approved.each do |comment|
      comment.approved_at.should_not be_nil
    end
    Comment.approved(1).each do |comment|
      comment.approved_at.should_not be_nil
    end
  end
  it "should act as a tree" do
    Comment.find(2).parent.should == Comment.find(1)
    Comment.find(1).children[0].should == Comment.find(2)
  end
  it "should have a spam list" do
    Comment.spam_list.should have(1).record
    Comment.spam_list(1).should have(1).record
  end
  it "should have an unapproved list" do
    Comment.unapproved.should have(2).records
    Comment.unapproved(1).should have(2).records
  end
  it "should have a user_agent and referrer" do
    @comment.user_agent.should be_nil
    @comment.referrer.should be_nil
  end
  it "should not be marked as spam" do
    @comment=Comment.new(:commentable_id=>1,:commentable_type=>'Post', :name=>'Rails Tester',:email=>'jefdean@gmail.com', :referrer=>'http://127.0.0.1/',
    :website=>'http://jefdean.com', :body=>'Hi, I really like your blog.', :ip=>'127.0.0.1', 
    :user_agent=>'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1) Gecko/20061010 Firefox/2.0')
    @comment.valid?.should be_true
    @comment.spam.should be_false
    @comment.check_spam
    @comment.spam.should be_false
  end
  it "should rebuild the Post search index after saving" do
    Post.rebuild_index
    Post.find_by_contents("another").size.should==0
    @comment.body="another comment"
    @comment.email="test@example.com"
    @comment.commentable_id=1
    @comment.commentable_type='Post'
    @comment.name="example"
    @comment.save!
    Post.find_by_contents("another").size.should==1
  end
end

describe "A SPAM Comment" do
  before(:each) do
    @comment=Comment.new(:commentable_id=>1,:commentable_type=>'Post',:name=>'viagra',:email=>'viagra@cialis.com', :website=>'viagra.com', :body=>'buy cheap drugs now', :ip=>'127.0.0.1', :user_agent=>'Mozilla')
    @comment.valid?.should be_true
    @comment.spam.should be_false
  end
  it "should be marked as such" do
    @comment.save.should be_true
    @comment.spam.should be_true
  end
  it "should be marked as spam" do
    @comment.check_spam
    @comment.spam.should be_true
  end
end

describe "A comment on a post closed for comments" do
  fixtures :posts, :comments
  it "should not save with a closed post" do
    c=Comment.new(:commentable=>Post.find(:first), :email=>'test@example.com', :name=>'test', :body=>'comment')
    c.should be_valid
    Post.find(:first).update_attributes(:comments_expire_at=>2.days.ago).should be_true
    c.commentable=Post.find(:first)
    c.valid?
    c.should have(1).errors_on(:base)
  end
end