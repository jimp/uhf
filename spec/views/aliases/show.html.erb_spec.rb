require File.dirname(__FILE__) + '/../../spec_helper'

describe "/page_paths/show.html.erb" do
  include PagePathsHelper
  
  before do
    @page_path = mock_model(PagePath)

    assigns[:page_path] = @page_path
  end

  it "should render attributes in <p>" do
    render "/page_paths/show.html.erb"
  end
end

