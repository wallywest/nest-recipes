include Chef::Resource::ApplicationBase

attribute :precompile_assets, :kind_of => [NilClass, TrueClass, FalseClass], :default => nil
attribute :seed, :kind_of => [NilClass, TrueClass, FalseClass], :default => nil
