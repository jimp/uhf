require File.dirname(__FILE__) + '/../../spec_helper'

describe "/events/show.html.erb" do
  include EventsHelper
  
  before do
    @event = mock_model(Event)

    assigns[:event] = @event
  end

  it "should render attributes in <p>" do
    render "/events/show.html.erb"
  end
end

