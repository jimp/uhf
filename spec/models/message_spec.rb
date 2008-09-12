require File.dirname(__FILE__) + '/../spec_helper'

describe "A New Message" do
  fixtures :messages
  before(:each) do
    @message = Message.new
  end
  it "should require recipients" do
    @message.valid?
    @message.should have(1).errors_on(:recipients)
  end  
  it "should require a from" do
    @message.valid?
    @message.should have(1).errors_on(:from)
  end  
  it "should require a subject" do
    @message.valid?
    @message.should have(1).errors_on(:subject)
  end  
  it "should require a body" do
    @message.valid?
    @message.should have(1).errors_on(:body)
  end  
  it "should have failures" do
    Message.failures.should have(2).records
  end
  it "should have successes" do
    Message.successes.should have(1).record
  end
  it "should have failures_since 15 days ago" do
    Message.failures_since(15.days.ago).should have(1).record
  end
  it "should send email after create" do
    p "NOT YET IMPLEMENTED"
  end
end

describe "A Valid SiteMailer and a Valid Message" do
  fixtures :messages
  before(:each) do
    SiteMailer.stub!(:deliver_user_message).and_return(true)
    @message=Message.new(:recipients=>'admin@admin.com', :from=>'from@from.com', :subject=>'subject', :body=>'body')
    @message.valid?.should be_true
  end
  it "should send_email" do
    @message.send_email.should be_true
  end
  it "should save the record" do
    lambda{@message.send_email}.should change(Message, :count).by(1)
  end
  it "should set the sent_on date" do
    @message.send_email
    @message.sent_on.day.should == Time.now.utc.day
  end
end

describe "A Valid SiteMailer and an Invalid Message" do
  fixtures :messages
  before(:each) do
    SiteMailer.stub!(:deliver_user_message).and_return(true)
    @message=Message.new(:recipients=>'admin@admin.com', :from=>'from@from.com')
    @message.valid?.should be_false
  end
  it "should not send_email" do
    @message.send_email.should be_false
  end
  it "should not save the record" do
    lambda{@message.send_email}.should_not change(Message, :count)
  end
  it "should not set the sent_on date" do
    @message.send_email
    @message.sent_on.should be_nil
  end
end

describe "An Invalid SiteMailer and a Valid Message" do
  fixtures :messages
  before(:each) do
    SiteMailer.stub!(:deliver_user_message).and_raise(RuntimeError)
    @message=Message.new(:recipients=>'admin@admin.com', :from=>'from@from.com', :subject=>'subject', :body=>'body')
    @message.valid?.should be_true
  end
  it "should not send_email" do
    @message.send_email.should be_false
  end
  it "should save the record" do
    lambda{@message.send_email}.should change(Message, :count).by(1)
  end
  it "should not set the sent_on date" do
    @message.send_email
    @message.sent_on.should be_nil
  end
  it "should set the error_message" do
    @message.error_message.should be_blank
    @message.send_email
    @message.error_message.should_not be_blank
    puts @message.error_message
  end
end