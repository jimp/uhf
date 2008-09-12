# == Schema Information
# Schema version: 15
#
# Table name: roles
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   default(""), not null
#  position   :integer(11)   default(0), not null
#  created_at :datetime      
#  updated_at :datetime      
#

# == Schema Information
# Schema version: 13
#
# Table name: roles
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   default(""), not null
#  position   :integer(11)   default(0), not null
#  created_at :datetime      
#  updated_at :datetime      
#

class Role < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :users
end
