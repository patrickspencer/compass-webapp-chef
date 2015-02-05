name             'webapp'
maintainer       'Patrick Spencer'
maintainer_email 'patrick.spencer@mail.mizzou.edu'
license          'All rights reserved'
description      'Installs/Configures webapp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'nginx'
depends 'postgresql'
depends 'database'
depends 'rbenv'