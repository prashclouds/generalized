#
# Cookbook Name:: ops-base
# Recipe:: common
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
%w{git git-flow git-core curl
  libmysqlclient-dev python-mysqldb mysql-client
  libxml2-dev libxslt1-dev
  libpcre3 libpcre3-dev
  gfortran g++
  libatlas-base-dev liblapack-dev
  libffi-dev
}.each {|p| package p }
require 'chef/log'
Chef::Log.level = :debug
