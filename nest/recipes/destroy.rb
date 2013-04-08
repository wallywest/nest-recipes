app = node[:nest][:app].gsub(/-/,"_")
repo = node[:nest][:repository]

#unicorn_service "#{app}" do
#  action [:stop]
#end

#nginx_site "#{app}.conf" do
#  enable false
#end

directory "#{node[:nest][:directory]}/#{app}" do
  recursive true
  action :delete
end

postgresql_database "#{app}" do
  connection ({:host => "127.0.0.1", :port => 5432, :username => 'deployer', :password => 'deployer'})
  action :drop
end
