set :application, "niche"
set :rails_env, "production"
set :deploy_to, "/var/www/apps/#{application}/#{rails_env}"
set :domain, "production.nicheprogram.org"
set :repository, "svn+ssh://deploy@svn.jasperdesign.com/var/repos/niche/trunk"
set :mongrel_conf,  "/etc/mongrel_cluster/#{application}_#{rails_env}.conf"

set :apache_proxy_port, 8020
set :apache_proxy_servers, 1
set :mongrel_servers, apache_proxy_servers

role :web, domain
role :app, domain
role :db,  domain, :primary => true
