# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include AuthenticatedSystem
  # include ExceptionNotifiable

  # Whenever any page in the site is called with ?print=true
  # it will render the contents of the page using app/views/layouts/print.html.erb
  # Then it test for ?save=true and uses app/views/layouts/save.html.erb
  # Otherwise it will render with /app/views/layouts/application.html.erb
  layout :set_layout  
  def set_layout
    if params[:save] && params[:save] == "true"
    "save"
    elsif params[:print] && params[:print] == "true"
      "print"
    else
      "application"
    end
  end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => "_uhf_#{ENV['RAILS_ENV']}_session_id"

  # set the global app_name, so it can be easily changed
  def app_name
    'UHF'
  end
  helper_method :app_name

  # set the global app_url, so it can be easily changed
  def app_url
    'http://www.uhf.org/'
  end
  helper_method :app_url

  # If you want timezones per-user, uncomment this:
  # before_filter :login_required
  # around_filter :set_timezone

  # set the thread's current user for use in the usermonitor
  before_filter :set_user
  def set_user
    Thread.current['user']=current_user.id if logged_in?
  end

  # determines if a user can edit content using the CMS
  before_filter :check_authorization
  def check_authorization
    @can_edit = true
    true # => set @can_edit, then return true so rails will keep rendering
  end

  # an accessor method for whether or not the user can edit the contents of this path
  # TODO: replace with current_user.can_edit and move the logic to the model
  def admin?
    !current_user.nil? && !current_user.is_a?(Symbol) && current_user.role && current_user.role.name=='admin'
  end
  helper_method :admin?

  # the default mode of authorization is the same as admin?
  def authorized?
    admin?
  end

  # gets the path portion of the url (everything after the /)
  # since we're not using the standard action/controller/id, this is important to set the body id and other page-specific settings
  # the path is only available when things are not mapped resources, so in these cases just use the controller name
  def app_path=(path)
    @app_path=path
  end
  def app_path
    @app_path ||= path_from_url
  end
  def path_from_url
    if controller_name=='pages'
      path = params[:path] && !params[:path].join('/').blank? ? params[:path].join('/') : 'index'
    else
      path = controller_name
    end
  end
  helper_method :app_path, :path_from_url

  def set_page_template
    @page_template = 'admin'
  end

  # determines whether or not this is a printed view or not
  def print?
    params[:print] && params[:print]=="true"
  end
  helper_method :print?

  private
  def set_timezone
    TzTime.zone = logged_in? ? current_user.tz : TimeZone.new('Etc/UTC')
    yield
    TzTime.reset!
  end

end
