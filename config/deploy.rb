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
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end