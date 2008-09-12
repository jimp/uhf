require File.dirname(__FILE__) + '/../../spec_helper'

describe "/events/edit.html.erb" do
  include EventsHelper
  
  before do
    @event = mock_model(Event)
    assigns[:event] = @event
  end

  it "should render edit form" do
    render "/events/edit.html.erb"
    
    response.should have_tag("form[action=#{event_path(@event)}][method=post]") do
    end
  end
end


