require File.dirname(__FILE__) + '/../../spec_helper'

describe "/messages/index.html.erb" do
  include MessagesHelper
  
  before do
    message_98 = mock_model(Message)
    message_99 = mock_model(Message)

    assigns[:messages] = [message_98, message_99]
  end

  it "should render list of messages" do
    render "/messages/index.html.erb"
  end
end

