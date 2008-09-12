# == Schema Information
# Schema version: 15
#
# Table name: assets
#
#  id           :integer(11)   not null, primary key
#  parent_id    :integer(11)   
#  filename     :string(255)   
#  thumbnail    :string(255)   
#  width        :integer(11)   
#  height       :integer(11)   
#  content_type :string(255)   
#  size         :integer(11)   
#  created_at   :datetime      
#  updated_at   :datetime      
#

# == Schema Information
# Schema version: 13
#
# Table name: assets
#
#  id           :integer(11)   not null, primary key
#  parent_id    :integer(11)   
#  filename     :string(255)   
#  thumbnail    :string(255)   
#  width        :integer(11)   
#  height       :integer(11)   
#  content_type :string(255)   
#  size         :integer(11)   
#  created_at   :datetime      
#  updated_at   :datetime      
#

class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true

  has_attachment :storage => :file_system, 
  :thumbnails => { :large => '400>', :medium => '150>', :small => '100>', :tiny => '50>' }, 
  :max_size => 5.megabytes,
  :path_prefix => "public/uploads"

  def parent
    return self if self.parent_id.nil?
    return self.class.find(self.parent_id)
  end

  # Gets the full path to the filename in this format:
  # public/uploads/<Type>[/thumbnail_size]/filename
  def full_filename(thumbnail = nil)
    media=['3GP','AAC','AAF','AIFF','ASF','AU','AVI','DSH','DWD','FLR','FLV','M1V','M2V','M4A','MKV','MNG','MOV','MP2','MP3','MPEG','MXF','NSV','OGM','RA','RKA','RM','SHN','SMI','SMP','SVI','SWA','WAV','WMA','WMV','WRAP','WV','Xvid']
    # check the content type
    if self.image?
      if self.thumbnail.blank? && thumbnail.blank?
        folder = 'Image'
      elsif self.thumbnail.blank? && !thumbnail.blank?
        folder = "Image/#{thumbnail.to_s.downcase}"
      else
        folder = "Image/#{self.thumbnail.downcase}"
      end
    elsif ['.swf','.fla','.flv'].include?(File.extname(filename))
      folder = 'Flash'
    elsif media.include?(File.extname(filename))
      folder = 'Media'
    else
      folder = 'File'
    end
    #File.join(RAILS_ROOT, 'public/uploads', folder , *partitioned_path(filename))
    logger.info File.join(RAILS_ROOT, 'public/uploads', folder , filename)
    File.join(RAILS_ROOT, 'public/uploads', folder , filename)
  end

  # Gets the thumbnail name for a filename.  'foo.jpg' becomes 'foo_thumbnail.jpg'
  def thumbnail_name_for(thumbnail = nil)
    return filename
  end

end
