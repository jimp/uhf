require 'railsmachine/recipes'

# PORTS
# Production App runs on 8000 - 8005
# Production Ferret Server runs on 9000
# Staging App runs on 8010
# Staging Ferret runs on 9010

# All jasper apps deploy a production instance and a staging instance 
# on the same server.  Staging is run in production mode, to mimic the
# live functionality as closely as possible 
set :user, "deploy"
set :server_prefix, "app005"
set :domain, "#{server_prefix}.jasper.railsmachina.com"
role :web, domain
role :app, domain, :primary => true
role :db,  domain, :primary => true
role :scm,  domain, :primary => true, :no_release => true

# Automatically symlink these directories from curent/public to shared/public.
set :app_symlinks, %w{uploads flash}

# The name of your application. Used for directory and file names associated with the application.
set :application, "uhf"

# The git repo
set :repository, "ssh://git@#{domain}/var/www/apps/#{application}/git"
set :git_location, "/var/www/apps/#{application}/git"
set :scm, :git

# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25
ssh_options[:paranoid] = false  

task :production do

  # Rails environment. Used by application setup tasks and migrate tasks.
  set :rails_env, "production"

  # Target directory for the application on the web and app servers.
  set :deploy_to, "/var/www/apps/#{application}/#{rails_env}"

  # =============================================================================
  # APACHE OPTIONS
  # =============================================================================
  set :apache_server_name, 'norcblueprint.org'

  # Use this to set the aliases like "www", "wwww", "ww" etc...
  set :apache_server_aliases, %w{uhf.jasperdesign.com norcblueprint.com}
  set :apache_conf, "/etc/httpd/conf/apps/#{application}_#{rails_env}.conf"
  set :apache_proxy_port, 8000
  set :apache_proxy_servers, 2
  # set :apache_ssl_enabled, true
  # set :apache_proxy_address, "127.0.0.1"
  # set :apache_ctl, "/etc/init.d/httpd"
  # set :apache_ssl_ip, "127.0.0.1"
  # set :apache_ssl_forward_all, false

  # =============================================================================
  # MONGREL OPTIONS
  # =============================================================================
  set :mongrel_servers, apache_proxy_servers
  set :mongrel_port, apache_proxy_port
  set :mongrel_conf, "/etc/mongrel_cluster/#{application}_#{rails_env}.conf"
  set :mongrel_environment, rails_env
  set :mongrel_pid_file, "/var/run/mongrel_cluster/#{application}_#{rails_env}.pid"
  # set :mongrel_address, apache_proxy_address
  # set :mongrel_user, user
  # set :mongrel_group, group
  
  set :ferret_script_name, "ferret_#{application}_#{rails_env}_ctl"
  set :ferret_ctl, "/etc/init.d/#{ferret_script_name}"
end

task :staging do
  set :rails_env, "staging"
  set :deploy_to, "/var/www/apps/#{application}/#{rails_env}"

  set :apache_server_name, "staging.uhfnyc.org"
  set :apache_proxy_port, 8010
  set :apache_conf, "/etc/httpd/conf/apps/#{application}_#{rails_env}.conf"
  set :apache_proxy_servers, 1
  set :apache_server_aliases, ["staging.#{application}.jasperdesign.com", "staging.uhfnyc.org"]
  # set :apache_ssl_enabled, true
  # set :apache_ssl_forward_all, false

  set :mongrel_servers, apache_proxy_servers
  set :mongrel_port, apache_proxy_port
  set :mongrel_environment, rails_env
  set :mongrel_conf, "/etc/mongrel_cluster/#{application}_#{rails_env}.conf"
  set :mongrel_pid_file, "/var/run/mongrel_cluster/#{application}_#{rails_env}.pid"
  
  set :ferret_script_name, "ferret_#{application}_#{rails_env}_ctl"
  set :ferret_ctl, "/etc/init.d/#{ferret_script_name}"
end

# =============================================================================
# CUSTOM
# =============================================================================
namespace :app do
  desc "Creates additional symlinks - then stops and starts the backgroundrb process for the file upload plugin"
  task :symlink_icons, :roles => [:app, :web] do
    run "ln -nfs /var/www/apps/shared/icons #{current_path}/public/images/icons"
  end
  
  desc "Moves the git location from the default location"
  task :move_git, :roles => [:scm] do
    sudo "mv #{deploy_to}/git /var/www/apps/#{application}/git"
  end
end
after "deploy:symlink", "app:symlink_icons"
after "git:setup", "app:move_git"

# =============================================================================
# FERRET
# =============================================================================
namespace :ferret do
  desc "Starts the ferret server"
  task :start, :roles => :app, :only => {:primary => true} do
    sudo "#{ferret_ctl} start"
  end

  desc "Stops the ferret server"
  task :stop, :roles => :app, :only => {:primary => true} do
    sudo "#{ferret_ctl} stop"
  end

  desc "Restarts the ferret server"
  task :restart, :roles => :app, :only => {:primary => true} do
    ferret.stop
    ferret.start
  end
  
  desc "Uploads the ferret startup script"
  task :install, :roles => :app, :only => {:primary => true} do 
    require 'erb'
    upload_path = "#{shared_path}/ferret" 
    template = File.read("config/templates/ferret_ctl.erb")
    file = ERB.new(template).result(binding) 
    put file, upload_path, :mode => 0755
    sudo "cp #{upload_path} #{ferret_ctl}"
    sudo "chmod +x #{ferret_ctl}"
    sudo "/sbin/chkconfig #{ferret_script_name} on"
  end 

  desc "Deletes the ferret startup script"
  task :uninstall, :roles => :app, :only => {:primary => true} do 
    sudo "/sbin/chkconfig #{ferret_script_name} off"
    sudo "rm -rf #{ferret_ctl}"
  end 
  
end
after "deploy:symlink", "ferret:restart"