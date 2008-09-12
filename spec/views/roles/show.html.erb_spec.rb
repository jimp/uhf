require File.dirname(__FILE__) + '/../../spec_helper'

describe "/roles/show.html.erb" do
  include RolesHelper
  
  before do
    @role = mock_model(Role)

    assigns[:role] = @role
  end

  it "should render attributes in <p>" do
    render "/roles/show.html.erb"
  end
end

