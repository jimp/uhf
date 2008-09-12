require File.dirname(__FILE__) + '/../../spec_helper'

describe "/comments/edit.html.erb" do
  include CommentsHelper
  
  before do
    @comment = mock_model(Comment)
    assigns[:comment] = @comment
  end

  it "should render edit form" do
    render "/comments/edit.html.erb"
    
    response.should have_tag("form[action=#{comment_path(@comment)}][method=post]") do
    end
  end
end


