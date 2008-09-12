xml.instruct!
xml.feed "xml:lang" => "en-US", "xmlns" => 'http://www.w3.org/2005/Atom' do
  xml.id("tag:#{request.host},2007:#{request.request_uri.split(".")[0].gsub("/", "")}")
  xml.link(:rel => 'self', :type => 'application/atom+xml', :href => atom_blog_url)
  xml.updated(@posts.first ? @posts.first.created_at : Time.now.utc)
  xml.title(app_name)

  for post in @posts
    xml.entry do 
      xml.id("tag:#{request.host_with_port},2007:#{post.class}#{post.id}")
      xml.published(post.published_at.xmlschema)
      xml.updated(post.updated_at.xmlschema)
      xml.title(post.title)
      xml.content(post.body, :type => 'html')
      xml.author do
        xml.name(app_name)
        xml.uri(app_url)
      end
      xml.link(:rel => 'alternate', :type => 'text/html', :href => post.url)
    end
  end
end