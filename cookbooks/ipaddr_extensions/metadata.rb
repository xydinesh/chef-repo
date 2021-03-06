name             'ipaddr_extensions'
maintainer       'Eric Saxby'
maintainer_email 'sax@livinginthepast.org'
license          'MIT'
description      'Adds the ipaddr_extensions gem to chef'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

recipe "ipaddr_extensions::default", "Installs ipaddr_extensions via chef_gem"

%w(redhat centos scientific fedora debian ubuntu arch freebsd amazon smartos).each do |platform|
  supports platform
end

# For chef < 11.6, this makes chef compatible with the RubyGems 2.0 API
suggests 'rubygems-compatibility'
