#
# Cookbook Name:: ops-docker
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
apt_repository 'juju' do
  uri 'https://apt.dockerproject.org/repo'
  components ['main']
  distribution 'ubuntu-trusty'
  key '58118E89F3A912897C070ADBF76221572C52609D'
  keyserver 'hkp://p80.pool.sks-keyservers.net:80'
  action :add
end

package 'docker-engine'

service 'docker' do
  action [:enable, :start]
end

group 'docker'
