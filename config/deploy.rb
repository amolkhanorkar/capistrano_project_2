set :application, "Sample_App"
set :repository,  "https://github.com/amolkhanorkar-webonise/capistrano_project_2"
set :scm, 'git'
set :branch, 'develop'

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.0.27"                          # Your HTTP server, Apache/etc
role :app, "192.168.0.27"                          # This may be the same as your `Web` server
role :db,  "192.168.0.27", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :deploy_to, "/var/www/capistrano_project_2"
set :use_sudo, false
set :normalize_asset_timestamps, false

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need

before :deploy, 'mysql:backup'
namespace :mysql do
  desc "performs a backup (using mysqldump)"
  task :backup, :roles => :db, :only => { :primary => true } do
   filename = "dump.#{Time.now.strftime'%d-%m-%Y@%T'}.sql"
    run "mysqldump -uroot -padmin sample_app_development > /tmp/Backup_capistrano_project_2/#{filename}"
   end
end 	  

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
