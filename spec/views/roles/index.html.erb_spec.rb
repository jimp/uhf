require File.dirname(__FILE__) + '/../../spec_helper'

describe "/roles/index.html.erb" do
  include RolesHelper
  
  before do
    role_98 = mock_model(Role)
    role_99 = mock_model(Role)

    assigns[:roles] = [role_98, role_99]
  end

  it "should render list of roles" do
    render "/roles/index.html.erb"
  end
end

