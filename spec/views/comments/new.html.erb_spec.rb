require File.dirname(__FILE__) + '/../../spec_helper'

describe "/comments/new.html.erb" do
  include CommentsHelper
  
  before do
    @comment = mock_model(Comment)
    @comment.stub!(:new_record?).and_return(true)
    assigns[:comment] = @comment
  end

  it "should render new form" do
    render "/comments/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", comments_path) do
    end
  end
end


