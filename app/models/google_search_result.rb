class GoogleSearchResult
  attr_accessor :mime_type, :index, :url, :escaped_url, :title, :snippet
  def initialize(element=nil)
    if element != nil
      self.mime_type = (element).attributes['mime']
      self.index = element.attributes['n'].to_i
      self.url = (element/:u).first.inner_html
      self.escaped_url = (element/:ue).first.inner_html
      self.title = CGI.unescapeHTML((element/:t).first.inner_html)
      self.snippet = CGI.unescapeHTML((element/:s).first.inner_html)
    end
  end
end