module ApplicationHelper
 
  def isCaregiver?
    @body_id == "Caregivers"
  end 

  # displays the help link for the id passed to it
  def help_link(id)
    %Q{<a class="help" href="##{id}">&nbsp;?&nbsp;</a>}
  end

  # Show the local time
  def tz(time_at)
    TzTime.zone.utc_to_local(time_at.utc)
  end

  # get a link for the main navigation
  def nav_link(text,url,tabindex,controller,action=nil)
    content_tag :dd, link_to(text, url, :tabindex=>tabindex+=1), :class=>(params[:controller]==controller && params[:action]==action ? 'currentCategory' : nil)
  end

  # each content block has a format - html, plain or textile
  # each attribute can be output using this format
  # to get the correct format for the block, pass in formatted_text(block, :text)
  def formatted_text(block, attribute)
    case block.markup.downcase
    when 'html'
      block.send(attribute)
    when 'textile'
      auto_link(textilize(block.send(attribute)))
    else
      auto_link(simple_format(h(block.send(attribute))))
    end
  end

  # gets the asset_id from the model with the image attachment
  # figures out what size they want to display
  # gets the correct filename
  def image_tag_for(imageable, *args)
    if imageable.asset
      size = nil
      case imageable.thumbnail_size
      when 'full'
        size = nil
      when ''
        size = nil
      when nil
        size = nil
      else
        size = imageable.thumbnail_size.to_sym
      end
      image_tag(imageable.asset.parent.public_filename(size), *args)
    end
  end

  def fckeditor_textarea(object, field, options = {})
    value = eval("@#{object}.#{field}")
    value = value.nil? ? "" : value
    id = fckeditor_element_id(object, field)

    cols = options[:cols].nil? ? '' : "cols='"+options[:cols]+"'"
    rows = options[:rows].nil? ? '' : "rows='"+options[:rows]+"'"

    width = options[:width].nil? ? '100%' : options[:width]
    height = options[:height].nil? ? '100%' : options[:height]

    html_width = width.to_s.starts_with?('%') ? width : "#{width}px"
    html_height = height.to_s.ends_with?('%') ? height : "#{height}px"
    
    toolbarSet = options[:toolbarSet].nil? ? 'Default' : options[:toolbarSet]

    if options[:ajax]
      inputs = "<input type='hidden' id='#{id}_hidden' name='#{object}[#{field}]'>\n"+    
      "<textarea id='#{id}' style=\"width:#{html_width};height:#{html_height}\" name='#{id}'>#{value}</textarea>\n"
    else 
      inputs = "<textarea id='#{id}' style=\"width:#{html_width};height:#{html_height}\" name='#{object}[#{field}]'>#{value}</textarea>\n"
    end

    base_path = request.relative_url_root.to_s+'/javascripts/fckeditor/'
    inputs + javascript_tag( "var oFCKeditor = new FCKeditor('#{id}', '#{width}', '#{height}', '#{toolbarSet}');\n"+
    "oFCKeditor.BasePath = \"#{base_path}\"\n"+
    "oFCKeditor.Config['CustomConfigurationsPath'] = '../../fckcustom.js';\n"+
    "if (FCKeditor_IsCompatibleBrowser()){oFCKeditor.ReplaceTextarea();};")                         
  end

  def fckeditor_form_remote_tag(options = {})
    editors = options[:editors]
    before = ""
    editors.keys.each do |e|
      editors[e].each do |f|
        before += fckeditor_before_js(e, f)
      end
    end
    options[:before] = options[:before].nil? ? before : before + options[:before] 
    form_remote_tag(options)
  end

  def fckeditor_remote_form_for(object_name, *args, &proc)
    options = args.last.is_a?(Hash) ? args.pop : {}
    concat(fckeditor_form_remote_tag(options), proc.binding)
    fields_for(object_name, *(args << options), &proc)
    concat('</form>', proc.binding)
  end
  alias_method :fckeditor_form_remote_for, :fckeditor_remote_form_for

  def fckeditor_element_id(object, field)
    id = eval("@#{object}.id")
    "#{object}_#{id}_#{field}_editor"    
  end

  def fckeditor_div_id(object, field)
    id = eval("@#{object}.id")  
    "div-#{object}-#{id}-#{field}-editor" 
  end

  def fckeditor_before_js(object, field)
    id = fckeditor_element_id(object, field)
    "var oEditor = FCKeditorAPI.GetInstance('"+id+"'); $('"+id+"_hidden').value = oEditor.GetXHTML();"
  end    

  def active_link_to(text,url)
    link_to(text,url,:class => (request.path.starts_with?(url) ? "active" : nil))
  end

  def login_link
    if logged_in?
      link_to "Logout", logout_url
    else
      link_to "Login", login_url
    end
  end

end
