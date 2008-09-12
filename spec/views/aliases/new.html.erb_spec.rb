require File.dirname(__FILE__) + '/../../spec_helper'

describe "/page_paths/new.html.erb" do
  include PagePathsHelper
  
  before do
    @page_path = mock_model(PagePath)
    @page_path.stub!(:new_record?).and_return(true)
    assigns[:page_path] = @page_path
  end

  it "should render new form" do
    render "/page_paths/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", page_paths_path) do
    end
  end
end


