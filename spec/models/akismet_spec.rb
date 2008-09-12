require File.dirname(__FILE__) + '/../spec_helper'

describe Akismet do
  before(:each) do
    Akismet.key="ef9c3ede1400"
    @blocker = Akismet.new
  end

  it "should verify key" do
    @blocker.has_verified_akismet_key?.should be_false
    @blocker.verify_akismet_key
    @blocker.has_verified_akismet_key?.should be_true
  end

  it "should have a ressetable key" do
    @blocker.key.should_not be_blank
    @blocker.key = ""
    @blocker.key.should == ""
  end

  it "should not approve known spam" do
    @blocker.is_spam?(:comment_author => 'viagra-test-123', 
    :user_ip => '127.0.0.1', 
    :user_agent => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1) Gecko/20061010 Firefox/2.0', 
    :referrer => 'http://127.0.0.1/',
    :comment_content => 'this comment_author triggers known spam',
    :blog=>Akismet.blog
    ).should be_true
  end

  it "should approve something harmless" do
    @blocker.is_spam?(:comment_author => 'Rails Tester', 
    :user_ip => '127.0.0.1', 
    :user_agent => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1) Gecko/20061010 Firefox/2.0', 
    :referrer => 'http://127.0.0.1/',
    :comment_content => 'Hi, I really like your blog.',
    :blog=>Akismet.blog
    ).should be_false
  end

end
