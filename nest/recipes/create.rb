app = node[:hive][:app].gsub(/-/,"_")
repo = node[:hive][:repository]
migration = node[:hive][:database]  && true
compile = node[:hive][:compile] || true
has_database = node[:hive][:database] || true

if has_database
  postgresql_database "#{app}" do
    connection ({ :username => 'root', :password => 'root'})
    action :create
  end
end

application "#{app}" do
  owner "deployer"
  group "deployer"
  path "#{node[:hive][:directory]}/#{app}"
  repository "#{repo}"
  revision "#{node[:hive][:revisions]}"
  migrate migration
  purge_before_symlink ["log"]
  symlinks "log"=> "log"
  hive_deploy true
  deploy_key node[:hive][:deploy_key]

  rails do
    bundler true
    precompile_assets compile

    db = "#{app}"
    database do
      adapter "postgresql"
      database db
      password 'deployer'
      username 'deployer'
    end
  end

  unicorn "#{node[:hive][:directory]}/#{app}/shared/unicorn.rb" do
    app_name "#{app}"
    worker_timeout node[:unicorn][:worker_timeout]
    preload_app node[:unicorn][:preload_app]
    worker_processes node[:unicorn][:worker_processes]
    pid "/opt/www/#{app}/shared/pids/unicorn.pid"
    stderr_path "/opt/www/#{app}/shared/log/unicorn.stderr.log"
    stdout_path "/opt/www/#{app}/shared/log/unicorn.stdout.log"
  end

  nginx_load_balancer do
     server_name "#{app}.websandbox.vail"
  end
end
