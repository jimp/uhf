# == Schema Information
# Schema version: 15
#
# Table name: comments
#
#  id               :integer(11)   not null, primary key
#  parent_id        :integer(11)   
#  body             :text          default(""), not null
#  name             :string(255)   default(""), not null
#  email            :string(255)   default(""), not null
#  website          :string(255)   
#  approved_at      :datetime      
#  ip               :string(255)   
#  referrer         :string(255)   
#  user_agent       :string(255)   
#  spam             :boolean(1)    not null
#  created_at       :datetime      
#  updated_at       :datetime      
#  commentable_id   :integer(11)   not null
#  commentable_type :string(255)   default(""), not null
#  created_by       :integer(11)   
#

# == Schema Information
# Schema version: 13
#
# Table name: comments
#
#  id               :integer(11)   not null, primary key
#  parent_id        :integer(11)   
#  body             :text          default(""), not null
#  name             :string(255)   default(""), not null
#  email            :string(255)   default(""), not null
#  website          :string(255)   
#  approved_at      :datetime      
#  ip               :string(255)   
#  referrer         :string(255)   
#  user_agent       :string(255)   
#  spam             :boolean(1)    not null
#  created_at       :datetime      
#  updated_at       :datetime      
#  commentable_id   :integer(11)   not null
#  commentable_type :string(255)   default(""), not null
#  created_by       :integer(11)   
#

class Comment < ActiveRecord::Base
  validates_presence_of :commentable_id, :commentable_type
  belongs_to :commentable, :polymorphic=>true
  validates_presence_of :body
  validates_presence_of :name
  validates_presence_of :email
  acts_as_tree :order=>'approved_at'

  # for pagination
  def self.per_page
    2
  end

  # before saving, check to see if it's spam
  before_create :check_spam

  # rebuild the index
  def after_save
    self.commentable.touch if self.commentable.is_a?(Post)
  end

  # don't allow saving comments to posts whose comments have expired
  def validate
    errors.add_to_base 'Comments for this post have been closed' if self.commentable && self.commentable.is_a?(Post) && self.commentable.comments_closed?
  end

  # returns only the approved comments, ordered by created date
  def self.approved(page=nil)
    with_scope(:find => { :conditions => "approved_at is not null", :order=>'created_at' }) do
      if page.nil? 
        find :all
      else
        paginate :all, :page=>page
      end
    end
  end

  # returns only the unapproved comments, ordered by created date
  def self.unapproved(page=nil)
    with_scope(:find => { :conditions => "approved_at is null", :order=>'created_at' }) do
      if page.nil? 
        find :all
      else
        paginate :all, :page=>page
      end
    end
  end

  # returns all comment marked as spam
  def self.spam_list(page=nil)
    with_scope(:find => { :conditions => "spam = true", :order=>'created_at' }) do
      if page.nil? 
        find :all
      else
        paginate :all, :page=>page
      end
    end
  end

  # check to see it it's spam
  def check_spam
    @blocker = Akismet.new
    @blocker.verify_akismet_key
    if @blocker.has_verified_akismet_key?
      self.spam = @blocker.is_spam? :comment_author => self.name, 
      :comment_author_email => self.email,
      :comment_author_url => self.website,
      :user_ip => self.ip, 
      :user_agent => self.user_agent, 
      :referrer => self.referrer,
      :comment_content => self.body,
      :blog=>Akismet.blog
    end
    true # => important - otherwise all saves fail unexpectedly when it's NOT spam
  end
end
