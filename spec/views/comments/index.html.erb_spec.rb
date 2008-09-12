require File.dirname(__FILE__) + '/../../spec_helper'

describe "/comments/index.html.erb" do
  include CommentsHelper
  
  before do
    comment_98 = mock_model(Comment)
    comment_99 = mock_model(Comment)

    assigns[:comments] = [comment_98, comment_99]
  end

  it "should render list of comments" do
    render "/comments/index.html.erb"
  end
end

