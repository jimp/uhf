require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/index.html.erb" do
  include PostsHelper
  
  before do
    post_98 = mock_model(Post)
    post_99 = mock_model(Post)

    assigns[:posts] = [post_98, post_99]
  end

  it "should render list of posts" do
    render "/posts/index.html.erb"
  end
end

