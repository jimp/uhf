# == Schema Information
# Schema version: 15
#
# Table name: pages
#
#  id                   :integer(11)   not null, primary key
#  partial_id           :integer(11)   not null
#  parent_id            :integer(11)   
#  path                 :string(255)   default(""), not null
#  title                :text          
#  link_text            :string(255)   
#  css_identifier       :string(255)   
#  description          :text          
#  jump_menu_position   :integer(11)   default(0), not null
#  include_in_main_menu :boolean(1)    not null
#  lft                  :integer(11)   not null
#  rgt                  :integer(11)   not null
#  lock_version         :integer(11)   default(0)
#  created_at           :datetime      
#  updated_at           :datetime      
#  show_children        :boolean(1)    default(TRUE), not null
#  show_siblings        :boolean(1)    default(TRUE), not null
#  show_breadcrumbs     :boolean(1)    default(TRUE), not null
#  page_type            :string(255)   
#

class Page < ActiveRecord::Base
  acts_as_nested_set
  acts_as_ferret :fields => [:path, :title, :link_text, :description, :url, :content_block_text], :remote=>true
  has_many :content_blocks, :as => :blockable
  has_many :aliases, :class_name=>'Alias', :dependent=>:destroy
  belongs_to :template, :class_name=>'Partial', :foreign_key=>'partial_id'
  validates_presence_of :path
  #validates_uniqueness_of :path, :scope=>:parent_id
  validates_format_of :path, :with=>/[-\w]/, :message=>'can only contain a-z, 0-9, "-" and "_" characters', :if=>:path?
  validates_presence_of :partial_id
  attr_accessor :parent_page_id # => we don't want to assign to parent_id directly, so we use this as a proxy when creating new records

  has_many :page_categories
  has_many :categories, :through => :page_categories

  class << self
    # loops through all of the rails routes
    # this little bit of magic comes straight from the rails routing code
    # path will look like /pages/:id or /pages.:format
    # break substitute / for all . and : characters, then split on /
    def existing_routes
      routes = []
      ActionController::Routing::Routes.routes.each do |route|
        path = route.segments.inject("") { |str,s| str << s.to_s }
        path = path.sub('.',"/").sub(":","/").gsub(/^\//,'').split('/').first
        routes << path.downcase unless path.blank?
      end
      routes.uniq
    end

    # a page's path determines it's url, which can change
    # to ensure that old paths still work, the path is stored in a separate table
    # the path is also a concatenated value based on all of the ancestors, so find_by_path will not work
    # to ensure that find_by_path works, we search through the page_paths table
    def find_by_alias(path)
      path = path.strip_slashes
      path = "/" if path=="index"
      aka = Alias.find_by_name(path)
      aka.nil? ? nil : aka.page
    end

    # returns all of the pages suitable to go in the sitemap
    # we only want top-level pages here, otherwise the recursion lists pages twice
    def sitemap
      find(:all, :conditions => ["parent_id is null and path not in('popups')"])
    end

    # The main menu consists of all top-level page that are marked as being included in the main menu
    def main_menu
      find(:all, :conditions=>'include_in_main_menu=true and parent_id is null', :order=>'lft')
    end

    # The main menu consists of any page where the jump_menu _position is greater than 0
    def jump_menu
      find(:all, :conditions=>'jump_menu_position > 0', :order=>'jump_menu_position')
    end

    # for pagination
    def per_page
      100
    end
    
    # returns the front page of the story that was updated last
    def featured_story
      story = find(:first, :conditions => {:parent_id => nil, :path => 'stories'})
      featured = find(:first, :conditions => ["lft > ? and rgt < ?", story.lft, story.rgt], :order => "updated_at desc")
      featured.parent && featured.parent.parent ? featured.parent : featured
    end

    # returns all of the story subpages
    def stories
      story = find(:first, :conditions => {:parent_id => nil, :path => 'stories'})
      story.children
    end

  end

  # make sure all paths are in the database correctly for all pages after each save and destroy
  def after_save
    Alias.update
  end  
  def after_destroy
    Alias.update
  end

  # before saving, strip the beginning and ending slashes
  # this way, we don't have to worry about it in the validations, and annoy users
  # but we still get clean data
  def before_validation
    self.path = self.path.strip.gsub(/\s/,'_').gsub(/\//,'_') unless self.path.blank?
    self.partial_id = Partial.default.id if self.partial_id.nil? || self.partial_id.zero?
  end

  # check page name against existing routes so that no overlaps occur
  def validate
    errors.add(:path, "is a reserved word and cannot be used") if self.path && self.class.existing_routes.include?(self.path.downcase)
  end

  # returns a list of all pages except those that are children of the current node
  def all_non_children
    exclude = self.all_children.map(&:id).join(',')
    results = exclude.blank? ? self.class.find(:all, :order=>'lft,path', :conditions=>["id != ?", self.id]) : self.class.find(:all, :conditions=>["id != ? and id not in (#{exclude})",self.id], :order=>'lft, path')
    results
  end

  # returns a web-ready url
  def url
    ("/"+self.self_and_ancestors.map(&:path).join("/").gsub(/^index/,'')+"/").gsub(/\/\//,'/')
  end

  # set some intelligent defaults
  def css_identifier
    self.attributes['css_identifier'].blank? ? (self.path.blank? ? 'index' : self.path) : self.attributes['css_identifier']
  end
  def link_text
    self.attributes['link_text'].blank? ? (self.path.blank? ? 'index' : self.path) : self.attributes['link_text']
  end

  # determines if this is the home page - since the home page is the only page that gets treated differently in the cms
  def index?
    self.path=='index' && self.parent_id.nil?
  end

  # joins all of the content_block text for the search index
  def content_block_text
    self.content_blocks.map(&:text).join(" ")
  end

  # this should rebuild the index
  def touch
    self.update_attributes(:updated_at=>Time.now.utc)
  end

  # finds the nearest sibling
  def nearest_sibling(direction)
    case direction
    when :left
      self.class.find(:first, :conditions=>["lft < :lft and parent_id #{self.parent_id.nil? ? 'is' : '='} :parent_id", {:lft=>self.lft, :parent_id=>self.parent_id}], :order=>'lft desc')
    when :right
      self.class.find(:first, :conditions=>["lft > :lft and parent_id #{self.parent_id.nil? ? 'is' : '='} :parent_id", {:lft=>self.lft, :parent_id=>self.parent_id}], :order=>'lft')
    else
      raise ArgumentError
    end
  end

  # moves the page left (up) one, if there is a place to move it
  def move_left!
    sibling = nearest_sibling(:left)
    sibling ? self.move_to_left_of(sibling) : false
  end

  # moves the page left (up) one, if there is a place to move it
  def move_right!
    sibling = nearest_sibling(:right)
    sibling ? self.move_to_right_of(sibling) : false
  end
end
