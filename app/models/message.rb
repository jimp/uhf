# == Schema Information
# Schema version: 15
#
# Table name: messages
#
#  id            :integer(11)   not null, primary key
#  recipients    :string(255)   default(""), not null
#  subject       :string(255)   default(""), not null
#  from          :string(255)   default(""), not null
#  cc            :string(255)   
#  bcc           :string(255)   
#  body          :text          
#  sent_on       :datetime      
#  error_message :text          
#  content_type  :string(255)   
#  headers       :string(255)   
#  ip_address    :string(255)   
#  created_at    :datetime      
#  updated_at    :datetime      
#

# == Schema Information
# Schema version: 13
#
# Table name: messages
#
#  id            :integer(11)   not null, primary key
#  recipients    :string(255)   default(""), not null
#  subject       :string(255)   default(""), not null
#  from          :string(255)   default(""), not null
#  cc            :string(255)   
#  bcc           :string(255)   
#  body          :text          
#  sent_on       :datetime      
#  error_message :text          
#  content_type  :string(255)   
#  headers       :string(255)   
#  ip_address    :string(255)   
#  created_at    :datetime      
#  updated_at    :datetime      
#

# The message class is used to store messages sent from users to the organization contacts
# It stores the message in the database after sending, in case there is an smtp error, no communication gets lost
# TODO: get messages since last login
class Message < ActiveRecord::Base
  validates_presence_of :recipients
  validates_presence_of :from
  validates_presence_of :subject
  validates_presence_of :body

  # Sends the message via SiteMailer and updates the sent_on parameter based on the success or failure of the mail action
  # If the record is invalid it will return false
  # If the message has already been sent, you must use force=true to resend
  # If there is an error in the smtp, the error_message is set, and it is saved
  # If there are no errors with SMTP, the object's sent_on field is set, and it's saved
  # All save errors are raised
  def send_email(force=false)
    return false unless valid?
    if sent_on.nil? || force==true
      begin
        SiteMailer.deliver_user_message(self)
        self.sent_on=Time.now.utc
        save!
      rescue Exception => e
        self.sent_on=nil
        self.error_message = "#{e.message.class} - #{e.message.inspect}"
        save!
        false
      end
    else
      false
    end
  end

  # Gets all failed messages
  def self.failures
    with_scope(:find => { :conditions => "sent_on is null" }) do
      find :all, :order=>'created_at desc'
    end    
  end

  # Gets all failed messages since the date specified
  def self.failures_since(date)
    with_scope(:find => { :conditions => "sent_on is null" }) do
      find :all, :order=>'created_at desc', :conditions=>["created_at > :date", {:date=>date}]
    end    
  end

  # Gest all messages that were reported as being sent successfully
  def self.successes
    with_scope(:find => { :conditions => "sent_on is not null" }) do
      find :all, :order=>'created_at desc'
    end    
  end
end
