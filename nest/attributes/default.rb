default[:nest][:directory] = "/opt/www"
default[:nest][:revision] = "master"

default[:unicorn][:worker_processes] = 1
default[:unicorn][:worker_timeout] = 60
default[:unicorn][:preload_app] = true
default[:unicorn][:options] = {:tcp_nodelay => true, :backlog => 1024}
