require File.dirname(__FILE__) + '/../../spec_helper'

describe "/roles/new.html.erb" do
  include RolesHelper
  
  before do
    @role = mock_model(Role)
    @role.stub!(:new_record?).and_return(true)
    assigns[:role] = @role
  end

  it "should render new form" do
    render "/roles/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", roles_path) do
    end
  end
end


