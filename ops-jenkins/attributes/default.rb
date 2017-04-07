default['java']['install_flavor'] = 'oracle'
default['java']['jdk_version'] = '8'
default['java']['accept_license_agreement'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true

default['jenkins']['master']['install_method'] = 'package'

default['caddy']['proxy'] = [{
  from: '/',
  to: '127.0.0.1:8080',
}]
