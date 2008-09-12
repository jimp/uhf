# == Schema Information
# Schema version: 15
#
# Table name: posts
#
#  id                 :integer(11)   not null, primary key
#  title              :string(255)   
#  body               :text          
#  published_at       :datetime      
#  comments_expire_at :datetime      
#  comments_count     :integer(11)   default(0), not null
#  created_at         :datetime      
#  updated_at         :datetime      
#

# == Schema Information
# Schema version: 13
#
# Table name: posts
#
#  id                 :integer(11)   not null, primary key
#  title              :string(255)   
#  body               :text          
#  published_at       :datetime      
#  comments_expire_at :datetime      
#  comments_count     :integer(11)   default(0), not null
#  created_at         :datetime      
#  updated_at         :datetime      
#

# The post class works in 2 modes:
#  * As a typical post - on record from the db
#  * As a calculated row - grouped by year and month, for the archives
class Post < ActiveRecord::Base
  acts_as_ferret :fields=>[:title, :body, :all_comments_text], :remote=>true
  validates_presence_of :body
  validates_presence_of :title
  validates_uniqueness_of :title
  has_many :comments, :as => :commentable
  has_many :approved_comments, :class_name=>'Comment', :conditions=>"approved_at is not null AND commentable_type='Post'", :foreign_key=>'commentable_id'
  attr_accessor :publish

  # Returns whether the comments are still open
  def comments_open?
    comments_expire_at.nil? || comments_expire_at > Time.now.utc
  end
  def comments_closed?
    !comments_open?
  end

  # Determines the number of posts to show on a given page
  # Also used to determines the default limit on find_by_date when no params are given
  def self.per_page
    15
  end

  # if publish is true, then set the published date
  # if publish is false, unset the published date
  # if publish is nil, do nothing
  def before_save
    case @publish
    when true
      self.published_at = Time.now.utc
    when false
      self.published_at = nil
    when nil
      # do nothing
    end
  end

  # returns a list of the posts that match the year/month/day parameters
  # if no day is given, it matches the months
  # if no month is given, it matches the year
  # if no year is given it returns the top n records (where n is per_page)
  def self.find_by_date(year=nil,month=nil,day=nil)
    limit = nil
    if !year.nil? && !month.nil? && !day.nil?
      conditions = ["MONTH(created_at)=:month and YEAR(created_at)=:year and DAYOFMONTH(created_at)=:day", {:month=>month, :year=>year, :day=>day}]
    elsif !year.nil? && !month.nil? && day.nil?
      conditions = ["MONTH(created_at)=:month and YEAR(created_at)=:year", {:month=>month, :year=>year}]
    elsif !year.nil? && month.nil? && day.nil?
      conditions = ["YEAR(created_at)=:year", {:year=>year}]
    elsif year.nil? && month.nil? && day.nil?
      limit = per_page
    end

    with_scope(:find => { :conditions => "published_at is not null" }) do
      find :all, 
      :conditions => conditions, 
      :order => "published_at desc",
      :limit => limit
    end
  end

  # returns a list of the posts that have a published_at date, ordered by published_at
  def self.published(id=nil)
    with_scope(:find => { :conditions => "published_at is not null" }) do
      if id.nil?
        find :all, :order=>'published_at'
      else
        begin
          find id
        rescue
          nil
        end
      end
    end
  end

  # returns a hash with the years and their months/month names
  # ordered by year (desc) and month (asc)
  def self.archives
    sql=<<-EOS
    SELECT id, YEAR(published_at) as year, MONTH(published_at) as month, DATE_FORMAT(published_at,'%M') as month_name
    FROM posts 
    WHERE published_at is not null 
    GROUP BY YEAR(published_at), MONTH(published_at) 
    ORDER BY year desc, month;
    EOS
    find_by_sql sql
  end

  # ======= Date-related functions ========

  # gets the year either from the "year" attribute or the published_at date
  def year
    if attributes["year"].blank?
      self.published_at? ? self.published_at.year.to_s : ""
    else
      attributes["year"]
    end
  end

  # gets the padded month from the "month" attribute - only appears on custom queries for archive
  def month
    if attributes["month"].blank?
      m = self.published_at? ? self.published_at.month : ""
    else
      m = attributes["month"]
    end
    m.blank? ? "" : m.to_s.rjust(2,"0")
  end

  # returns the month name of the published_at date or the "month_name" attribute
  def month_name
    if attributes["month_name"].blank?
      self.published_at? ? self.published_at.strftime("%B") : ""
    else
      attributes["month_name"]
    end
  end

  #returns the padded day
  def day
    self.published_at? ? self.published_at.day.to_s.rjust(2,"0") : ""
  end

  # returns the day name for the blog
  def day_name
    self.published_at? ? self.published_at.strftime("%A") : ""
  end

  # returns a date like Wednesday, August 22nd, 2007
  def pretty_date
    self.published_at? ? self.published_at.strftime("%A, %B %d, %Y") : ""
  end

  # returns a time like 8:30 AM, or 10:40 PM
  def pretty_time
    self.published_at? ? self.published_at.strftime("%I:%M %p").gsub(/^0/,'') : ""
  end

  # returns the full url for the blog - I know, this should be handled by routes, but it's just so easy here...
  def url(atom=false)
    self.published_at? && !new_record? ? self.published_at.strftime("/blog/%Y/%m/%d/#{self.id}#{atom ? '.atom' : ''}") : ""
  end

  # returns the archive url for the month
  def archive_url(atom=false)
    year.blank? || month.blank? || new_record? ? "" : "/blog/#{year}/#{month}#{atom ? '.atom' : '/'}"
  end
  
  # return all comments text for the search index
  def all_comments_text
    self.comments.map(&:body).join(' ')
  end

  # update the "updated_at" and search index
  def touch
    self.update_attributes(:updated_at=>Time.now.utc)
  end
    
end
