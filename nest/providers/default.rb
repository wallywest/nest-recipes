action :before_compile do
  new_resource.environment.update({
   "RAILS_ENV" => "production"
  })
end

action :before_deploy do
  create_database_yml
end

action :before_migrate do

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


  setup_pg_config
  bundle_install_command

  link "#{new_resource.release_path}/config/database.yml" do
    to "#{new_resource.path}/shared/config/database.yml"
  end
end

action :before_symlink do
  compile_assets
end
action :before_restart do
end
action :after_deploy do
end
action :after_restart do
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

def setup_pg_config
  rbenv_script "setup pg gem" do
    rbenv_version "1.9.3-p392"
    user  "deployer"
    cwd   new_resource.release_path
    code  "bundle config build.pg --with-pg-config=/usr/pgsql-9.2/bin/pg_config"
  end
end

def bundle_install_command
  common_groups = %w{development test cucumber staging}
  rbenv_script "bundle install" do
    rbenv_version "1.9.3-p392"
    user          "deployer"
    group         "deployer"
    cwd           new_resource.release_path
    code          "bundle install --deployment --binstubs --path=vendor/bundle --without #{common_groups}"
  end
end

def compile_assets
  execute "./bin/rake assets:precompile" do
    cwd new_resource.release_path
    user "deployer"
  end
end
