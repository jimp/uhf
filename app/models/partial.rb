class Partial < ActiveRecord::Base
  validates_presence_of :directory
  validates_presence_of :name
  has_many :pages
  
  # TODO: add basic file management here - check if the file actually exists, create or delete it etc...
  # TODO: write a form for super-admins to create these on the fly!
  
  # If there are no partials, create one
  # If there are partials, return the first one
  def self.default
    if count > 0
      find :first
    else
      create :name=>'default', :directory=>'templates', :description=>'Auto-Generated'
    end
  end
end
