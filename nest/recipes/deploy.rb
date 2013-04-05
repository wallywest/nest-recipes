app = node[:nest][:app].gsub(/-/,"_")
repo = node[:nest][:repository]
path = "#{node[:nest][:directory]}/#{app}"
revision = node[:nest][:revision]
migrate = node[:nest][:migrate]
force = node[:nest][:force]

deploy_revision "#{path}" do
  action force ? :force_deploy : :deploy
  user "deployer"
  group "deployer"
  repository repo
  revision revision
  migrate migrate
  environment "RAILS_ENV" => "production"
  shallow_clone true
  symlinks(
    "log" => "log",
  )
  keep_releases 5
  enable_submodules true
  rollback_on_error true

  before_deploy do
     puts "WTF BEFORE DEPLOY"
  end

  before_migrate do

    template "#{path}/shared/config/database.yml" do
      source "database.yml.erb"
      owner "deployer"
      group "deployer"
      mode "644"
      variables(
        :host => "localhost",
        :adapter => "postgresql",
	:database => "#{app}",
        :rails_env => "production"
      )
    end

  end
end

unicorn_service "#{app}" do
  action [:upgrade]
end
