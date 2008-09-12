class Pdfs < ActiveRecord::Base
  has_attachment :content_type => 'application/pdf', :storage => :file_system, :path_prefix => 'public/pdfs'
  validates_as_attachment
  
  def path
    full_filename =~ /#{RAILS_ROOT}\/public\/(.*)/
    $1
  end
  
end
