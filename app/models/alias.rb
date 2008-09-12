# == Schema Information
# Schema version: 15
#
# Table name: aliases
#
#  id         :integer(11)   not null, primary key
#  page_id    :integer(11)   
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

# == Schema Information
# Schema version: 13
#
# Table name: aliases
#
#  id         :integer(11)   not null, primary key
#  page_id    :integer(11)   
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Alias < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page_id
  validates_presence_of :name
  validates_uniqueness_of :name

  # strip begninning and end slashes, except if it's the index page
  def before_validation
    self.name = self.name.strip.gsub(/^\//,'').chomp('/') unless self.name.blank? || self.name.strip=='/'
  end
  
  # loops through all of the pages and inserts records into aliases if necessary
  # returns the number of new records inserted into the database
  def self.update
    # first, cleanup old paths
    delete_all("page_id not in (select id from pages)")
    
    # cleanup the path, check if it's the home page, and insert all necessary paths
    record_count = 0
    for page in Page.find(:all)
      aka = find_or_initialize_by_name(page.url.strip_slashes)
      if aka.new_record? || aka.page_id!=page.id
        aka.page_id=page.id
        aka.save
        record_count += 1
      end
    end
    record_count
  end
  
  # returns a url suitable for redirect_to in the controller
  def url
    self.name=='/' ? '/' : "/#{self.name}"
  end

end
