# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'pitchhub'
#set :repo_url, 'git@github.com:mrwinton/pitchhub.git'

set :repo_url, 'git@github.com:interns2016/pitchhub.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/pitchhub'
set :deploy_to, '/home/michael/pitchhub'


# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :scm, "git"
set :user, "michael"  # The server's user for deploys
set :user, "interns"
set :log_level, :debug

set :linked_files, %w{config/local_env.yml}

namespace :deploy do

  desc 'Create a shared directory to keep the files that we do not keep in git'
  task :setup_config do
    # create a shared directory to keep files that are not in git and that are used for the application
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
    end
    puts File.read("config/local_env.yml.example"), "#{shared_path}/config/local_env.yml"
    puts "Now edit the config files in #{shared_path}."
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

# namespace :deploy do
#
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end
#
#   after :publishing, :restart
#
#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
#
# end
