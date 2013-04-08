app = node[:nest][:app].gsub(/-/,"_")
repo = node[:nest][:repository]
path = "#{node[:nest][:directory]}/#{app}"
revision = node[:nest][:revision]
migrate = node[:nest][:migrate]
force = node[:nest][:force]

postgresql_database "#{app}" do
  connection ({:host => "127.0.0.1", :port => 5432, :username => 'deployer', :password => 'deployer'})
  action :create
end

%w{cached-copy config log pids}.each do |dir|
  directory "#{path}/shared/#{dir}" do
    owner "deployer"
    group "deployer"
    mode '0755'
    recursive true
    action :create
  end
end

template "#{path}/shared/unicorn.rb" do
  source "unicorn.rb.erb"
  owner "deployer"
  group "deployer"
  app_name "#{app}"
  listen({"/tmp/#{app}.sock" => node[:unicorn][:options]})
  worker_timeout node[:unicorn][:worker_timeout]
  preload_app node[:unicorn][:preload_app]
  worker_processes node[:unicorn][:worker_processes]
  pid "/opt/www/#{app}/shared/pids/unicorn.pid"
  stderr_path "/opt/www/#{app}/shared/log/unicorn.stderr.log"
  stdout_path "/opt/www/#{app}/shared/log/unicorn.stdout.log"
end
