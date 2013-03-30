app = node[:hive][:app]
command = node[:hive][:action]

case command
when "restart"
  unicorn_service "#{app}" do
    action [:restart]
  end
when "start"
  unicorn_service "#{app}" do
    action [:stop, :start]
  end
when "stop"
  unicorn_service "#{app}" do
    action [:stop]
  end
else
  Chef::Debug.log("action is not permitted")
end
