require File.dirname(__FILE__) + '/../spec_helper'

describe ContactController do

  #Delete this example and add some real ones
  it "should use ContactController" do
    controller.should be_an_instance_of(ContactController)
  end

  it "should send message when posting" do
    SiteMailer.should_receive(:deliver_admin_email).with(@message)
  end

end
