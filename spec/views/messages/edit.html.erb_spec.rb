require File.dirname(__FILE__) + '/../../spec_helper'

describe "/messages/edit.html.erb" do
  include MessagesHelper
  
  before do
    @message = mock_model(Message)
    assigns[:message] = @message
  end

  it "should render edit form" do
    render "/messages/edit.html.erb"
    
    response.should have_tag("form[action=#{message_path(@message)}][method=post]") do
    end
  end
end


