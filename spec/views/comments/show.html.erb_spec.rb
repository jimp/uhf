require File.dirname(__FILE__) + '/../../spec_helper'

describe "/comments/show.html.erb" do
  include CommentsHelper
  
  before do
    @comment = mock_model(Comment)

    assigns[:comment] = @comment
  end

  it "should render attributes in <p>" do
    render "/comments/show.html.erb"
  end
end

