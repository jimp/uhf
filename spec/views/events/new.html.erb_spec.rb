require File.dirname(__FILE__) + '/../../spec_helper'

describe "/events/new.html.erb" do
  include EventsHelper
  
  before do
    @event = mock_model(Event)
    @event.stub!(:new_record?).and_return(true)
    assigns[:event] = @event
  end

  it "should render new form" do
    render "/events/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", events_path) do
    end
  end
end


