require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones or delete this file
describe "Given a generated pages_helper_spec.rb" do
  helper_name 'pages'
  
  it "the PagesHelper should be included" do
    (class << self; self; end).class_eval do
      included_modules.should include(PagesHelper)
    end
  end
end
