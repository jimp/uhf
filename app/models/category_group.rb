class CategoryGroup < ActiveRecord::Base
  has_many :categories, :dependent => :destroy
  has_many :page_categories, :through => :categories
  acts_as_list
  
end
