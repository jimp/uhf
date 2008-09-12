# == Schema Information
# Schema version: 15
#
# Table name: page_categories
#
#  id          :integer(11)   not null, primary key
#  page_id     :integer(11)   
#  category_id :integer(11)   
#  created_at  :datetime      
#  updated_at  :datetime      
#

# == Schema Information
# Schema version: 13
#
# Table name: page_categories
#
#  id          :integer(11)   not null, primary key
#  page_id     :integer(11)   
#  category_id :integer(11)   
#  created_at  :datetime      
#  updated_at  :datetime      
#

class PageCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :page
end
