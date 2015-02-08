#
# Cookbook Name:: compass-webapp
# Recipe:: default
#
# Copyright 2015, Patrick Spencer
#
# License: MIT
#

include_recipe "nginx"
include_recipe "database::postgresql"
include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

package "vim"
package "git"

user "#{node.user.name}"

rbenv_ruby "2.1.5" do
  global true
end

rbenv_gem "bundler" do
  ruby_version "2.1.5"
end

# execute 'bundle install' do
#   cwd "#{node.app.web_dir}/app"
#   not_if 'bundle check' # This is not run inside /myapp
# end

directory node.app.web_dir do
  owner node.user.name
  mode "0755"
  recursive true
end

directory "#{node.app.web_dir}/public" do
  owner node.user.name
  mode "0755"
  recursive true
end

directory "#{node.app.web_dir}/logs" do
  owner node.user.name
  mode "0755"
  recursive true
end

template "#{node.nginx.dir}/sites-available/#{node.app.name}.conf" do
  source "webapp/nginx.conf.erb"
  mode "0644"
end

# It's import to have this git resource before
# the template resource below the references unicorn.rb
git "#{node.app.web_dir}/app" do
  repository "git://github.com/patrickspencer/compass-webapp"
  reference "master"
  action :sync
end

template "#{node.app.web_dir}/app/config/unicorn.rb" do
  source "webapp/unicorn.rb.erb"
  mode "0644"
end


file "#{node.nginx.dir}/sites-enabled/default" do
  action :delete
end

nginx_site "#{node.app.name}.conf" do
  enable true
end

cookbook_file "#{node.app.web_dir}/public/index.html" do
  source "index.html"
  mode "0755"
  owner node.user.name
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
  password node['compass_db_user']['db_password']
  privileges [:all]
  action :create
end
