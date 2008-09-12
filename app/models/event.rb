# == Schema Information
# Schema version: 15
#
# Table name: events
#
#  id            :integer(11)   not null, primary key
#  name          :string(255)   default(""), not null
#  description   :text          
#  start_date    :datetime      
#  end_date      :datetime      
#  location_name :string(255)   
#  address       :string(255)   
#  city          :string(255)   
#  state         :string(255)   
#  zip           :string(255)   
#  lat           :decimal(15, 1 
#  lng           :decimal(15, 1 
#  created_at    :datetime      
#  updated_at    :datetime      
#

# == Schema Information
# Schema version: 13
#
# Table name: events
#
#  id            :integer(11)   not null, primary key
#  name          :string(255)   default(""), not null
#  description   :text          
#  start_date    :datetime      
#  end_date      :datetime      
#  location_name :string(255)   
#  address       :string(255)   
#  city          :string(255)   
#  state         :string(255)   
#  zip           :string(255)   
#  lat           :decimal(15, 1 
#  lng           :decimal(15, 1 
#  created_at    :datetime      
#  updated_at    :datetime      
#

class Event < ActiveRecord::Base
  # gets a formatted version of the address
  def location(separator=', ', prefix='', suffix='')
    loc = location_name
    %w{address city state zip}.each do |att|
      loc += "#{separator}#{self.send(att)}" if !loc.blank?  && !self.send(att).blank? 
    end
    loc.blank? ? '' : "#{prefix}#{loc}#{suffix}"
  end  
end
