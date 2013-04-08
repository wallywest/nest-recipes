actions :start, :stop, :enable, :disable, :restart, :upgrade

attribute :action, :kind_of => [StringClass], :default => nil
attribute :running, :default => false
attribute :enabled, :default => false
