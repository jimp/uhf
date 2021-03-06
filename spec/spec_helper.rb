# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures'
  config.before(:each, :behaviour_type => :controller) do
    #raise_controller_errors
  end
  include AuthenticatedTestHelper

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.

  def mock_admin_user
    role = mock_model(Role,:name=>'admin')
    user = mock_model(User, 
      :id => 1, 
      :tz => TimeZone.new('USA/PDT'),
      :login => 'flappy',
      :email => 'flappy@email.com',
      :password => '', :password_confirmation => '',
      :time_zone => 'USA/PDT',
      :role => role
    )
  end
  
end
