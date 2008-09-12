# A set of tasks designed to run on the remote servers via cron tasks
#
# To install the cron tasks, see deploy.rb#cron:install
namespace :chores do

  desc "Tasks to be run hourly by the app server"
  task :hourly => :environment do
    chore("Hourly") do
    end
  end
  
  desc "Tasks to be run daily by the app server"
  task :daily => :environment do
    chore("Daily") do
      db_config = YAML::load( File.open( 'config/database.yml' ) )
      system "mkdir -p #{db_backup_dir}"
      system "mysqldump -u#{db_config[RAILS_ENV]["username"]} -p#{db_config[RAILS_ENV]["password"]} #{db_config[RAILS_ENV]["database"]}  | gzip > #{db_backup_dir}/#{db_config[RAILS_ENV]["database"]}-#{date}.sql.gz"
      system "/usr/bin/env rsync -a #{dir}/shared/public #{backup_dir}"
    end
  end
  
  desc "Tasks to be run weekly by the app server"
  task :weekly => :environment do
    chore("Weekly") do
      # Your Code Here
    end
  end
  
  # Executes the given chore and logs the task and the
  # times to the log defined in config/templates/cron.erb
  def chore(name)
    puts "#{name} Task Invoked: #{Time.now}"
    yield
    puts "#{name} Task Finished: #{Time.now}"
  end

  # Returns a date formatted as a two digit day-of-month
  # For March 31st it would return 31
  # For January 3rd it would return 03
  def date
    Date.today.day.to_s.rjust(2,"0")
  end

  # The base directory where we store the app, and where
  # we'll store the backups
  def dir
    "/var/www/apps/uhf"
  end

  # The backup directory
  def backup_dir
    "#{dir}/backups"
  end

  # The database backup directory
  def db_backup_dir
    "#{backup_dir}/mysql"
  end

end
