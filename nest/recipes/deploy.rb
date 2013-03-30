app = node[:hive][:app].gsub(/-/,"_")
repo = node[:hive][:repository]
rev = node[:hive][:revision] || "HEAD"
migration = (node[:hive][:migrate] ||= true) && node[:hive][:database]
compile = node[:hive][:compile] || false
force = node[:hive][:force] || false

application "#{app}" do
  owner "deployer"
  group "deployer"
  path "#{node[:hive][:directory]}/#{app}"
  repository "#{repo}"
  revision "#{rev}"
  migrate migration
  hive_deploy force
  purge_before_symlink ["log"]
  symlinks "log"=> "log"
  deploy_key node[:hive][:deploy_key]

  db = "#{app}"

  rails do
    bundler true
    precompile_assets compile

    database do
      adapter "postgresql"
      database db
      password 'deployer'
      username 'deployer'
    end
  end
end

unicorn_service "#{app}" do
  action [:upgrade]
end
