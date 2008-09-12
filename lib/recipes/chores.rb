# Provides easy access to the sysadmin chores defined in lib/tasks/chores.rake
namespace :chores do
  
  [:hourly, :daily, :weekly].each do |job|
    desc "Runs rake chores:#{job} on the remote server"
    task job, :roles => [:app] do
      chore(job.to_s)
    end
  end

  def chore(name)
    run "cd #{current_path} && rake RAILS_ENV=#{rail_env} chores:#{name}"
  end

end

# Rails recipes suggest adding the following lines:
# before "deploy:stop", "cron:install" 
# after "deploy:start", "cron:uninstall"
# However, there is no need for that, since the current path never changes
# Instead, I've chosen to install it after deploy:cold
# Any time you update the cron file, you can run cap cron:install
namespace :cron do 
  
  task :install, :roles => :app, :only => {:primary => true} do 
    cron_tab = "#{shared_path}/cron.tab" 
    run "mkdir -p #{shared_path}/log/cron" 
    require 'erb' 
    template = File.read("config/templates/cron.erb") 
    file = ERB.new(template).result(binding) 
    put file, cron_tab, :mode => 0644 
    # merge with the current crontab 
    # fails with an empty crontab, which is acceptable 
    run "crontab -l >> #{cron_tab}" rescue nil 
    # install the new crontab 
    run "crontab #{cron_tab}" 
  end 

  task :uninstall, :roles => :app, :only => {:primary => true} do 
    cron_tmp = "#{shared_path}/cron.old" 
    cron_tab = "#{shared_path}/cron.tab" 
    begin 
      # dump the current cron entries 
      run "crontab -l > #{cron_tmp}" 
      # remove any lines that contain the application name 
      run "awk '{if ($0 !~ /#{application}/) print $0}' " + 
      "#{cron_tmp} > #{cron_tab}" 
      # replace the cron entries 
      run "crontab #{cron_tab}" 
    rescue 
      # fails with an empty crontab, which is acceptable 
    end 
    # clean up 
    run "rm -rf #{cron_tmp}" 
  end 
  
end 
after "deploy:cold", "cron:install"