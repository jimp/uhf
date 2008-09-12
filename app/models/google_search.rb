require 'open-uri'
class GoogleSearch

  attr_accessor :total_results, :current_page, :per_page, :results, :time, :query, :next_page, :previous_page, :url, :first_result, :last_result, :pages

  # set results to always return an array regardless
  def initialize
    self.results = []
  end

  # Queries the google search api and returns exactly 1
  def self.search(q,start=0,num=10)
    start = start.to_i
    result = new
    result.url = url = construct_url(q,start,num)

    # Grab the doc with Hpricot
    doc = Hpricot(open(url))

    # Grab the high-level variables
    result.time = (doc/:tm).inner_html.to_f
    result.query = (doc/:q).inner_html

    # get pagination info
    # todo - move this to the instance and make them readonly
    result.total_results = (doc/:m).inner_html.to_i
    if (doc/:res).length > 0
      result.first_result = (doc/:res).first.attributes['sn'].to_i
      result.last_result = (doc/:res).first.attributes['en'].to_i
      result.per_page = num
      result.pages = (result.total_results / result.per_page)+1
      result.current_page = (result.first_result / result.per_page)+1

      if (doc/:nb).length > 0
        result.next_page = CGI.unescapeHTML((doc/:nu).inner_html) if (doc/:nu).length > 0
        result.previous_page = CGI.unescapeHTML((doc/:pu).inner_html) if (doc/:pu).length > 0
      end

      # Get the actual search results
      (doc/:r).each{|r|
        result.results << GoogleSearchResult.new(r)
      }
    end
    result
  end

  # creates the url, using the custom escape_url method
  def self.construct_url(q,start=0,num=10)
    "http://www.google.com/search?start=#{start}&num=#{num}&q=#{url_escape(q)}&client=google-csbe&output=xml_no_dtd&cx=#{GOOGLE_SEARCH_API_KEY}&hl=en"
  end

  # CGI.escape turns spaces into the %20 character, and I want plus signs, so I use this method instead
  def self.url_escape(term)
    CGI.escape(term).gsub('%20','+')
  end

end
