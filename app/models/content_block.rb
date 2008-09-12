# == Schema Information
# Schema version: 15
#
# Table name: content_blocks
#
#  id             :integer(11)   not null, primary key
#  group          :string(255)   default(""), not null
#  text           :text          
#  position       :integer(11)   default(0), not null
#  created_at     :datetime      
#  updated_at     :datetime      
#  blockable_id   :integer(11)   not null
#  blockable_type :string(255)   default(""), not null
#

# == Schema Information
# Schema version: 13
#
# Table name: content_blocks
#
#  id             :integer(11)   not null, primary key
#  group          :string(255)   default(""), not null
#  text           :text          
#  position       :integer(11)   default(0), not null
#  created_at     :datetime      
#  updated_at     :datetime      
#  blockable_id   :integer(11)   not null
#  blockable_type :string(255)   default(""), not null
#

class ContentBlock < ActiveRecord::Base
  attr_protected :created_at, :created_by
  belongs_to :blockable, :polymorphic=>true
  
  # update the page search index
  def after_save
    self.blockable.touch if self.blockable_type == 'Page'
  end
  
  #This strips off the surrounding <p> entered by the editor
  def just_text
    return $1 if text =~ /^<p>(.*)<\/p>$/
    text
  end
  
end
