# == Schema Information
# Schema version: 15
#
# Table name: users
#
#  id                        :integer(11)   not null, primary key
#  role_id                   :integer(11)   
#  prefix                    :string(255)   
#  first                     :string(255)   
#  last                      :string(255)   
#  title                     :string(255)   
#  login                     :string(255)   
#  email                     :string(255)   
#  crypted_password          :string(40)    
#  salt                      :string(40)    
#  last_login_at             :datetime      
#  remember_token            :string(255)   
#  remember_token_expires_at :datetime      
#  time_zone                 :string(255)   default("Etc/UTC")
#  created_at                :datetime      
#  updated_at                :datetime      
#

# == Schema Information
# Schema version: 13
#
# Table name: users
#
#  id                        :integer(11)   not null, primary key
#  role_id                   :integer(11)   
#  prefix                    :string(255)   
#  first                     :string(255)   
#  last                      :string(255)   
#  title                     :string(255)   
#  login                     :string(255)   
#  email                     :string(255)   
#  crypted_password          :string(40)    
#  salt                      :string(40)    
#  last_login_at             :datetime      
#  remember_token            :string(255)   
#  remember_token_expires_at :datetime      
#  time_zone                 :string(255)   default("Etc/UTC")
#  created_at                :datetime      
#  updated_at                :datetime      
#

require 'digest/sha1'
class User < ActiveRecord::Base
  include AuthenticatedBase

  has_many :site_users
  has_many :sites
  belongs_to :role

  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )

  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_presence_of :role_id

  # Protect internal methods from mass-update.
  attr_accessible :login, :email, :password, :password_confirmation, :time_zone

  # gets a formatted name - or the login name if first/last are blank
  def name
    name = (self.first.to_s + " " + self.last.to_s).strip
    name.blank? ? self.login : name
  end

  def previous_user
    user = self.class.find(:first, :conditions=>["id < ?", self.id])
    user = self.class.find(:first, :order=>"id desc") if user.nil?
    user.id
  end
  
  def next_user
    user = self.class.find(:first, :conditions=>["id > ?", self.id])
    user = self.class.find(:first) if user.nil?
    user.id
  end

end
