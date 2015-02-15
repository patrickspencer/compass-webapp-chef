#
# Cookbook Name:: compass-webapp
# Recipe:: default
#
# Copyright 2015, Patrick Spencer
#
# License: MIT
#

include_recipe "nginx"
include_recipe "apt"
include_recipe "database::postgresql"
include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "nodejs"
include_recipe "redis2"

package "vim"
package "git"
package "libpq-dev"
package "libsqlite3-dev"
package "libssl-dev"
package "telnet"
package "postfix"
package "curl"
package "zlib1g-dev"
package "libreadline-dev"
package "libyaml-dev"
package "sqlite3"
package "libxml2-dev"
package "libxslt1-dev"
package "build-essential"
package "tree"

user node['user']

# set timezone
bash "set timezone" do
  code <<-EOH
  echo 'US/Central' > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
  EOH
  not_if "date | grep -q 'CST'"
end

rbenv_ruby "2.1.5" do
  global false
end

rbenv_gem "bundler" do
  ruby_version "2.1.5"
end

directory node.app.dir do
  owner node.user
  mode "0755"
  recursive true
end

directory "#{node.app.dir}/public" do
  owner node['user']
  mode "0755"
  recursive true
end

directory "#{node.app.dir}/logs" do
  owner node['user']
  mode "0755"
  recursive true
end

directory node['redis']['dir'] do
  owner node['user']
  mode "0644"
  recursive true
end

template "#{node.nginx.dir}/sites-available/#{node.app.name}.conf" do
  source "webapp/nginx.conf.erb"
  mode "0644"
end

# It's import to have this git resource before
# the template resource below the references unicorn.rb
git "#{node.app.dir}/app" do
  repository "git://github.com/patrickspencer/compass-webapp"
  reference "master"
  action :sync
end

template "#{node.app.dir}/app/config/unicorn.rb" do
  source "webapp/unicorn.rb.erb"
  mode "0644"
end

execute 'bundle install' do
  cwd "#{node.app.dir}/app"
  # not_if 'bundle check' # This is not run inside /myapp
  environment 'ARCHFLAGS' => "-arch x86_64"
end

# file "#{node.nginx.dir}/sites-enabled/default" do
#   action :delete
# end

file "#{node.nginx.dir}/sites-enabled/000-default" do
  action :delete
end

nginx_site "#{node.app.name}.conf" do
  enable true
end

cookbook_file "#{node.app.dir}/public/index.html" do
  source "index.html"
  mode "0755"
  owner node['user']
end

directory "#{node.app.dir}/pids" do
  owner node['user']
  mode '0644'
  action :create
end

# set unicorn config
template "/etc/init.d/unicorn_#{node['app']['name']}" do
  source "webapp/unicorn.sh.erb"
  mode 0755
  owner node['user']
  group node['group']
end

# add init script link
execute "update-rc.d unicorn_#{node['app']['name']} defaults" do
  not_if "ls /etc/rc2.d | grep unicorn_#{node['app']['name']}"
end

postgresql_database 'compass_db_prod' do
  connection(
    :host      => 'localhost',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  action :create
end

postgresql_database 'compass_db_dev' do
  connection(
    :host      => 'localhost',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  action :create
end

postgresql_database 'compass_db_test' do
  connection(
    :host      => 'localhost',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  action :create
end

postgresql_database_user 'compass_db_user' do
  connection(
    :host      => '127.0.0.1',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  database_name 'compass_db_prod'
  database_name 'compass_db_dev'
  database_name 'compass_db_test'
  password node['postgresql']['password']['postgres']
  privileges [:all]
  action :create
end

redis_instance "datastore" do
  port 8866
  data_dir "/mnt/redis/datastore"
  master master_node
  nofile 16384
end
