action :before_compile do 
end

action :before_deploy do
  create_database_yml
end

action :before_migrate do
  Chef::Log.info "Running bundle install"
  directory "#{new_resource.path}/shared/vendor_bundle" do
    owner new_resource.owner
    group new_resource.group
    mode '0755'
  end
  directory "#{new_resource.release_path}/vendor" do
    owner new_resource.owner
    group new_resource.group
    mode '0755'
  end
  link "#{new_resource.release_path}/vendor/bundle" do
    to "#{new_resource.path}/shared/vendor_bundle"
  end

  bundle_install_command
end

action :before_symlink do
end
action :before_restart do
end
action :after_deploy do
end

def create_database_yml
    template "#{new_resource.path}/shared/config/database.yml" do
      source "database.yml.erb"
      owner "deployer"
      group "deployer"
      mode "644"
      variables(
        :host => "localhost",
        :adapter => "postgresql",
	:database => "#{new_resource.name}",
        :rails_env => "production"
      )
    end
end

def bundle_install_command
  common_groups = %w{development test cucumber staging}
  execute "bundle install --deployment --binstubs --path=vendor/bundle --without #{common_groups}" do
    cwd new_resource.release_path
    user new_resource.owner
    environment = "production"
  end
end
