require File.dirname(__FILE__) + '/../../spec_helper'

describe "/page_paths/edit.html.erb" do
  include PagePathsHelper
  
  before do
    @page_path = mock_model(PagePath)
    assigns[:page_path] = @page_path
  end

  it "should render edit form" do
    render "/page_paths/edit.html.erb"
    
    response.should have_tag("form[action=#{page_path_path(@page_path)}][method=post]") do
    end
  end
end


