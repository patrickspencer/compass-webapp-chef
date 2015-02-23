default['user']              = 'compass_webapp'
default['group']             = 'www-data'

default['ruby']['version']   = '2.1.5'
default['redis']['version']  = '2.8.19'
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
# default['postgresql']['version']                         = '9.4'

default['rbenv']['user_installs'] = [
  { 'user'    => default['user'],
    'rubies'  => ['2.1.5'],
    'global'  => '2.1.5',
    'gems'    => {
      '2.1.5'    => [
        { 'name'    => 'bundler' },
        { 'name'    => 'rake' }
      ]
    }
  }
]
