# config valid for current version and patch releases of Capistrano
#lock "~> 3.14.0"

# -------------------------------
# Basic Settings
# -------------------------------
set :application,     'mopxopminhphat'
set :repo_url,        'git@gitlab.com:fagotek/waker.git'
set :user,            'ubuntu'
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"

# -------------------------------
# Git / Branch
# -------------------------------
set :branch,          'master'
set :deploy_via,      :copy

# -------------------------------
# RVM
# -------------------------------
set :rvm_type,        :user
set :rvm_ruby_version, '3.2.4@mopxopminhphat' # sửa theo ruby bạn dùng
set :rvm_custom_path, '~/.rvm'  # thêm vào dưới rvm_ruby_version

# -------------------------------
# Linked Files & Directories
# -------------------------------
# Linked Files & Directories
set :linked_files, %w[.env config/database.yml]

set :linked_dirs, %w[
  log
  tmp/pids
  tmp/cache
  tmp/sockets
  public/system
  public/uploads
  public/storage
]
# -------------------------------
# Keep Releases
# -------------------------------
set :keep_releases, 2

# -------------------------------
# Puma Settings
# -------------------------------
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # nếu dùng ActiveRecord

# -------------------------------
# SSH Options
# -------------------------------
set :pty, false
set :use_sudo, false
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

# -------------------------------
# Tasks
# -------------------------------

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/tmp/sockets"
      execute "mkdir -p #{shared_path}/tmp/pids"
    end
  end

end

namespace :deploy do
  desc 'Check local git is in sync with remote'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  # Nếu không dùng migration, bỏ qua
  Rake::Task["deploy:migrate"].clear_actions
  task :migrate do
    puts "No migrations"
  end

  # Rake::Task["deploy:assets:precompile"].clear
  # Rake::Task["deploy:assets:backup_manifest"].clear

  # Map deploy start/stop/restart to Puma
  desc 'Start application'
  task :start do
    on roles(:app) do
      invoke 'puma:start'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      invoke 'puma:stop'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc 'Initial deploy'
  task :initial do
    on roles(:app) do
      invoke 'deploy'
      invoke 'deploy:start'
    end
  end

  # Hooks
  before :starting, :check_revision
  after  :finishing, :compile_assets
  after  :finishing, :cleanup
end
