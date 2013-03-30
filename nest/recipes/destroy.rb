service 'nginx'

app = node[:hive][:app].gsub(/-/,"_")
repo = node[:hive][:repository]

nginx_site "#{app}.conf" do
  enable false
end

unicorn_service "#{app}" do
  action [:stop]
end

directory "#{node[:hive][:directory]}/#{app}" do
  recursive true
  action :delete
end

postgresql_database "#{app}" do
  connection ({ :username => 'root', :password => 'root'})
  action :drop
end

