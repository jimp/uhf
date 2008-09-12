xml.instruct!
xml.feed "xml:lang" => "en-US", "xmlns" => 'http://www.w3.org/2005/Atom' do
  xml.id("tag:#{request.host},2007:#{request.request_uri.split(".")[0].gsub("/", "")}")
  xml.link(:rel => 'self', :type => 'application/atom+xml', :href => @post.url(true))
  xml.updated(@post.published_at)
  xml.title(@post.title)
  xml.author do
    xml.name(app_name)
    xml.uri(app_url)
  end

  for comment in @post.comments
    xml.entry do 
      xml.id("tag:#{request.host_with_port},2007:#{comment.class}#{comment.id}")
      xml.published(comment.created_at.xmlschema)
      xml.updated(comment.updated_at.xmlschema)
      xml.title(comment.name)
      xml.content(comment.body, :type => 'html')
      xml.author do
        xml.name(comment.name)
        xml.uri(comment.website) if comment.website?
      end
      xml.link(:rel => 'alternate', :type => 'text/html', :href => comment_url(comment))
    end
  end
end