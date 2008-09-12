require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/new.html.erb" do
  include PostsHelper
  
  before do
    @post = mock_model(Post)
    @post.stub!(:new_record?).and_return(true)
    assigns[:post] = @post
  end

  it "should render new form" do
    render "/posts/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", posts_path) do
    end
  end
end


