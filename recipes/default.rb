#
# Cookbook Name:: webapp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx"
include_recipe "database::postgresql"
include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby "2.1.5" do
  force true
  global true
end

nginx_site "default" do
  enable true
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
