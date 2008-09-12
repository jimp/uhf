class AjaxController < ApplicationController

  def popup
    
    if request.xml_http_request?
      /http:\/\/.*?\/(.*)/ =~ request.request_parameters().to_s
      text = $1
      
      page = Page.find_by_alias(text)
      text = ""
      if page.nil?
        text = 'Page ' + $1.to_s + ' not found'
      else
        page.content_blocks.each { |block| text = block.text if block.group == 'main' }
      end
    end

    respond_to do |type|
      type.js { }
    end
    render :update do |page|
      page.call 'showFig', text;
    end
  end

end
