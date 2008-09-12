require File.dirname(__FILE__) + '/../../spec_helper'

describe "/events/index.html.erb" do
  include EventsHelper
  
  before do
    event_98 = mock_model(Event)
    event_99 = mock_model(Event)

    assigns[:events] = [event_98, event_99]
  end

  it "should render list of events" do
    render "/events/index.html.erb"
  end
end

