app = node[:nest][:app].gsub(/-/,"_")
repo = node[:nest][:repository]
path = "#{node[:nest][:directory]}/#{app}"
revision = node[:nest][:revision]
migrate = node[:nest][:migrate]
force = node[:nest][:force]
key = node[:nest][:deploy_key]

%w{cached-copy config log pids system}.each do |dir|
  directory "#{path}/shared/#{dir}" do
    owner "deployer"
    group "deployer"
    mode '0755'
    recursive true
    action :create
  end
end

application "#{app}" do

  action :force_deploy
  path "#{path}"
  owner "deployer"
  group "deployer"
  repository repo
  revision revision
  migrate migrate
  migration_command "./bin/rake db:migrate"
  deploy_key key

  nest
end
