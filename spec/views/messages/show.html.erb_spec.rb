require File.dirname(__FILE__) + '/../../spec_helper'

describe "/messages/show.html.erb" do
  include MessagesHelper
  
  before do
    @message = mock_model(Message)

    assigns[:message] = @message
  end

  it "should render attributes in <p>" do
    render "/messages/show.html.erb"
  end
end

