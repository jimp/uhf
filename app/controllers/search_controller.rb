class SearchController < ApplicationController

  # GET /search?q=
  # The Jasper CMS has 2 built-in search modes
  # <tt>Google Search</tt> - This connects to the google custom search via the api key in /config/initialiers/google.rb
  # <tt>Ferret Search</tt> - uses the acts_as_ferret plugin to do a full text search of the database
  # To turn google search on, set up a google custom search and add the api key to the google.rb file and restart the app
  # The search will seemlessly go to google
  #
  # TODO: create a fallback mechanism where if google fails, it will go to ferret search and email admins
  def index
    if is_google_search?
      do_google_search
    else
      do_ferret_search
    end    
  end
  
  protected

  def do_google_search
    unless params[:q].blank?
      @search=GoogleSearch.search(params[:q],params[:start])
    else
      flash[:notice]='Please Specify a Search Term'
    end    
    render :action=>'google'
  end

  def do_ferret_search
    unless params[:q].blank?
      term = "*#{params[:q].split.join('* OR *')}*"
      @pages=Page.paginate_search(term,:page=>params[:page])
    else
      flash[:notice]='Please Specify a Search Term'
    end    
    render :action=>'ferret'
  end

  def is_google_search?
    !GOOGLE_SEARCH_API_KEY.blank?
  end
  
end
