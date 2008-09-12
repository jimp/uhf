class GuestBook < ActiveRecord::Base
  #This validates that name is actually a valide email address
  validates_format_of :name, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix, :message => 'Need a valid email address'
  validates_presence_of :comment, :message => 'Need a comment'  
end
