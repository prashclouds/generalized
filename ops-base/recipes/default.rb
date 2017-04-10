#
# Cookbook Name:: ops-base
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe "ntp"
include_recipe "#{cookbook_name}::common"
include_recipe "ops-clamav"
include_recipe "ops-icinga2::client"
include_recipe "ops-snapshot"

