require File.dirname(__FILE__) + '/../spec_helper'

describe SiteMailer do
  include ActionMailer::Quoting

  before(:each) do
    @message = mock_model(Message, :subject=>'Subject', :body=>'Body', :recipients=>'admin@example.com', :from=>'user@example.com', :cc=>'', :bcc=>'')
    # You don't need these lines while you are using create_ instead of deliver_
    #ActionMailer::Base.delivery_method = :test
    #ActionMailer::Base.perform_deliveries = true
    #ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type 'text', 'plain', { 'charset' => 'utf-8' }
    @expected.mime_version = '1.0'
  end

  it 'should send user_message' do
    @expected.subject = 'Subject'
    @expected.body    = 'Body'
    @expected.from    = 'user@example.com'
    @expected.to      = 'admin@example.com'

    SiteMailer.create_admin_message(@message).encoded.should == @expected.encoded
  end
end