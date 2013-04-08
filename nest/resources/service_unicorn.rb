actions :start, :stop, :enable, :disable, :restart, :upgrade

attribute :service_name,:name_attribute => true
attribute :running, :default => false
attribute :enabled, :default => false
