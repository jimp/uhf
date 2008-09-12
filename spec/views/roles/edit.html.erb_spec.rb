require File.dirname(__FILE__) + '/../../spec_helper'

describe "/roles/edit.html.erb" do
  include RolesHelper
  
  before do
    @role = mock_model(Role)
    assigns[:role] = @role
  end

  it "should render edit form" do
    render "/roles/edit.html.erb"
    
    response.should have_tag("form[action=#{role_path(@role)}][method=post]") do
    end
  end
end


