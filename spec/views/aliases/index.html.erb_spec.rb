require File.dirname(__FILE__) + '/../../spec_helper'

describe "/page_paths/index.html.erb" do
  include PagePathsHelper
  
  before do
    page_path_98 = mock_model(PagePath)
    page_path_99 = mock_model(PagePath)

    assigns[:page_paths] = [page_path_98, page_path_99]
  end

  it "should render list of page_paths" do
    render "/page_paths/index.html.erb"
  end
end

