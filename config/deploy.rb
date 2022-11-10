# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "qna"
set :repo_url, "https://github.com/IvanKOS7/qna.git"
set :branch, 'main'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ubuntu/qna"
set :deploy_user, 'ubuntu'
set :rvm_map_bins, %w{gem rake ruby rails bundle}
# set :rvm_custom_path, '/usr/share/rvm'
set :default_env, { path: "~/home/ubuntu/.rvm/rubies/ruby-2.5.3/bin:$PATH" }
# set :rvm_ruby_version, '2.5.3'
# Default value for :format is :airbrussh.
# set :format, :airbrussh
# after "bundle:install", "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true
set :linked_dirs, fetch(:linked_dirs, []) << '.bundle'
# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# namespace :deploy do
#   desc "assets precompile"
#   task :precompile do
#     on roles(:rails) do
#       execute "cd #{release_path} && bundle exec rake assets:precompile RAILS_ENV=#{fetch(:production)} "
#     end
#   end
#   after :publishing, :precompile
# end     
# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
