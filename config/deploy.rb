set :user, "miklme"
set :domain, "miklme@mikl.me"
set :application, "miklme"
set :deploy_to, "/home/miklme/git/miklme"
set :repository, "miklme@mikl.me:home/miklme/git/miklme"
set :scm,"git"
set :branch,"master"

namespace :vlad do
  desc "Symlinks the configuration files"
  remote_task :symlink_config, :roles => :web do
    %w(application.yml database.yml).each do |file|
      run "ln -s #{shared_path}/config/#{file} #{current_path}/config/#{file}"
    end
  end

  desc "Full deployment cycle: Update, migrate, restart, cleanup"
  remote_task :deploy, :roles => :app do
    Rake::Task['vlad:update'].invoke
    Rake::Task['vlad:symlink_config'].invoke
    Rake::Task['vlad:migrate'].invoke
    Rake::Task['vlad:start_app'].invoke
    Rake::Task['vlad:cleanup'].invoke
  end
end
