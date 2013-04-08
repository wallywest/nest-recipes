default[:nest][:directory] = "/opt/www"
default[:nest][:revision] = "master"
default[:nest][:seed] = true
default[:nest][:assets] = true

default[:unicorn][:worker_processes] = 1
default[:unicorn][:worker_timeout] = 60
default[:unicorn][:preload_app] = true
default[:unicorn][:options] = {:tcp_nodelay => true, :backlog => 1024}
