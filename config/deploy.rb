require "rvm/capistrano"
require "bundler/capistrano"

set :deploy_to, "/home/deploy/app2014"
set :repository,  "git@github.com:smeade/app2014.git"
set :rvm_ruby_string, "2.0.0"
set :use_sudo, false
set :deploy_via, :remote_cache

set :user, "deploy"
set :server_ip, "162.243.149.201"
role :app, server_ip
role :web, server_ip
role :db, server_ip , :primary => true

# set :port, 22

after "deploy:restart", "deploy:cleanup"
after "deploy", "rvm:trust_rvmrc"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  namespace :db do

    desc "Syncs the database.yml file from the local machine to the remote machine"
    task :sync_yaml do
      puts "\n\n=== Syncing database yaml to the production server! ===\n\n"
      unless File.exist?("config/database.yml")
        puts "There is no config/database.yml.\n "
        exit
      end
      system "rsync -vr --exclude='.DS_Store' config/database.yml #{user}@#{application}:#{shared_path}/config/"
    end
    
    desc "Create Production Database"
    task :create do
      puts "\n\n=== Creating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:create RAILS_ENV=production"
      #system "cap deploy:set_permissions"
    end

    desc "Migrate Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate RAILS_ENV=production"
      #system "cap deploy:set_permissions"
    end

    desc "Resets the Production Database"
    task :migrate_reset do
      puts "\n\n=== Resetting the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate:reset RAILS_ENV=production"
    end
    
    desc "Destroys Production Database"
    task :drop do
      puts "\n\n=== Destroying the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:drop RAILS_ENV=production"
      #system "cap deploy:set_permissions"
    end

    desc "Populates the Production Database"
    task :seed do
      puts "\n\n=== Populating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:seed RAILS_ENV=production"
    end

  end
    

end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
