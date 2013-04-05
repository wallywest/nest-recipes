include_recipe "nginx"

app = node[:nest][:app].gsub(/-/,"_")
repo = node[:nest][:repository]
path = "#{node[:nest][:directory]}/#{app}"
revision = node[:nest][:revision]
migrate = node[:nest][:migrate]
force = node[:nest][:force]

template "#{node['nginx']['dir']}/sites-available/#{app}.conf" do
    source "nginx.conf.erb"
    owner "root"
    group "root"
    mode "644"
    variables(
	:app => app,
    ) 
    notifies :reload, resources(:service => 'nginx')
end

nginx_site "#{app}.conf"
