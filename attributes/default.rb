default['user']              = 'compass_webapp'
default['group']             = 'www-data'
# default['nodejs']['dir']     = '/usr/local'
# default['nodejs']['version'] = '0.12.0'
default['nodejs']['install_method'] = 'binary'

default['ruby']['version']   = '2.1.5'
default['redis']['version']  = '2.8.13'
default['redis']['dir']  = '/mnt/redis'
default['nginx']['version']  = '1.2.3'
default['nginx']['default_site_enabled']  = 'true'
default['nginx']['source']['modules']  = ['http_gzip_static_module,','http_ssl_module']
default['db']['name']        = 'compass_webapp_db'
default['db']['user']        = 'compass_webapp'
default['app'] = {
  :name => 'compass_webapp',
  :user => 'compass_webapp',
  :dir  => '/var/www/compass_webapp'
}
default['webdir'] = '/var/www/compass_webapp/app'

default['postgresql']['version']                         = '9.4'
# arch = node['kernel']['machine'] =~ /x86_64/ ? 'x64' : 'x86'
# package_stub = "node-v#{node['nodejs']['version']}-linux-#{arch}"
# nodejs_tar = "#{package_stub}.tar.gz"
# nodejs_url = "http://nodejs.org/dist/v#{node['nodejs']['version']}/#{nodejs_tar}"
# executable = "#{node['nodejs']['dir']}/bin/node"




