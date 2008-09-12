require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/edit.html.erb" do
  include PostsHelper
  
  before do
    @post = mock_model(Post)
    assigns[:post] = @post
  end

  it "should render edit form" do
    render "/posts/edit.html.erb"
    
    response.should have_tag("form[action=#{post_path(@post)}][method=post]") do
    end
  end
end


