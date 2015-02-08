name             'compass-webapp-chef'
maintainer       'Patrick Spencer'
maintainer_email 'patrick.spencer@mail.mizzou.edu'
license          'All rights reserved'
description      'Installs/Configures webapp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'nginx-2.7.4'
depends 'postgresql-3.4.14'
depends 'database-3.1.0'
depends 'rbenv-1.7.0'
