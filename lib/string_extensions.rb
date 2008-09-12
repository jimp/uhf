class String
  def strip_slashes
    self.strip == "/" ? self.strip : self.strip.gsub(/^\//,'').chomp('/')
  end
end