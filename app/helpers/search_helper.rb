module SearchHelper

  # the urls can be quite long, so this splits them into 2 lines if they are that long
  def format_url(url)
    if url.length > 80
      "#{url[0..40]}<br/>#{url[41..80]}"
    else
      url
    end
  end

  # when google returns a mime_type that we recognize, display it like they do
  def mime_type_for(result)
    return "" if result.mime_type.blank?
    type = case result.mime_type
    when "application/pdf" : 'PDF'
    when "application/msword" : 'DOC'
    when "application/vnd.ms-powerpoint" : 'PPT'
    else ""
    end    
    return type if type.blank?    
    return '<span style="font-size:.8em;">['+type+']</span> '    
  end

  # a pagination helper
  def search_url_for(search, direction)
    case direction
    when :first
      start = 0
    when :next
      start = search.last_result
    when :previous
      start = search.first_result - search.per_page - 1
    when :last
      start = (search.pages-1) * search.per_page
    else 
      raise 'Direction must be one of :next or :previous'
    end
    "/search?start=#{start}&q=#{search.query}"
  end

  # pagination for google results
  def google_pagination_links(search)
    # 10/2 will == 0, but that means there is actually 1 page
    show_first_page = search.pages > 1 && search.current_page > 1
    show_last_page = search.pages > 1 && search.current_page < search.pages
    show_first_last = search.pages > 2
    html = ""
    if search.pages > 1
      html += link_to_if(show_first_page && show_first_last, ' &laquo ', search_url_for(search, :first))
      html += link_to_if(search.previous_page, ' &lt; previous ', search_url_for(search,:previous))
      html += link_to_if(search.next_page, ' next &gt; ', search_url_for(search,:next))
      html += link_to_if(show_last_page && show_first_last, ' &raquo ', search_url_for(search, :last))
    end
  end

end
