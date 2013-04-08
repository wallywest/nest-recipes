require 'chef/mixin/shell_out'
require 'chef/mixin/language'

include Chef::Mixin::ShellOut

def load_current_resource
  @current_resource = Chef::Resource::NestServiceUnicorn.new(new_resource.name)
  @current_resource.service_name(new_resource.service_name)
  
  Chef::Log.debug("Checking status of service #{new_resource.service_name}")

  @current_resource
end

action :start do
  shell_out!(start_command)
  new_resource.updated_by_last_action(true)
end

action :restart do
  shell_out!(restart_command)
  new_resource.updated_by_last_action(true)
end

action :stop do
  shell_out!(stop_command)
  new_resource.updated_by_last_action(true)
end

action :upgrade do
  shell_out!(upgrade_command)
  new_resource.updated_by_last_action(true)
end

def start_command 
  "/etc/init.d/unicorn start #{new_resource.name}"
end

def stop_command
  "/etc/init.d/unicorn stop #{new_resource.name}"
end

def restart_command
  "/etc/init.d/unicorn restart #{new_resource.name}"
end

def upgrade_command
  "/etc/init.d/unicorn upgrade #{new_resource.name}"
end
