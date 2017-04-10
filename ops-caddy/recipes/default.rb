#
# Cookbook Name:: ops-caddy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
user node['caddy']['user'] do
  system true
  home '/etc/caddy'
end

directory '/etc/caddy' do
  owner node['caddy']['user']
end

remote_file '/tmp/caddy_linux_amd64_custom.tar.gz' do
  source node['caddy']['url']
end

bash 'put-caddy-to-location' do
  cwd '/tmp'
  code <<-CMD
    tar xvf /tmp/caddy_linux_amd64_custom.tar.gz;
    mv caddy /usr/local/bin/
    chmod +x /usr/local/bin/caddy
    setcap cap_net_bind_service=+ep /usr/local/bin/caddy
  CMD
  not_if 'test -f /usr/local/bin/caddy'
end

template '/etc/init/caddy.conf' do
  source 'upstart.erb'
end

template '/etc/caddy/Caddyfile' do
  source 'caddyfile.erb'
end
