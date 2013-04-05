app = node[:nest][:app].gsub(/-/,"_")
repo = node[:nest][:repository]
path = "#{node[:nest][:directory]}/#{app}"
revision = node[:nest][:revision]
migrate = node[:nest][:migrate]
force = node[:nest][:force]

%w{cached-copy config log pids bundle system}.each do |dir|
  directory "#{path}/shared/#{dir}" do
    owner "deployer"
    group "deployer"
    mode '0755'
    recursive true
    action :create
  end
end

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
  #nest_deploy true
  #deploy_key node[:nest][:deploy_key]
end
