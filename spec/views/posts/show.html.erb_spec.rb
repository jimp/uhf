require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/show.html.erb" do
  include PostsHelper
  
  before do
    @post = mock_model(Post)

    assigns[:post] = @post
  end

  it "should render attributes in <p>" do
    render "/posts/show.html.erb"
  end
end

