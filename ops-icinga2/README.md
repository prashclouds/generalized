# icinga2

## Cookbook Dependencies

- yum version 3.13.0
You can see the official documentation here
https://supermarket.chef.io/cookbooks/yum/versions/3.13.0

- apt version 2.9.2
You can see the official documentation here
https://supermarket.chef.io/cookbooks/apt/versions/2.9.2

- nrpe version 1.5.3
You can see the official documentation here
https://supermarket.chef.io/cookbooks/nrpe/versions/1.5.3

- python version 1.4.6
You can see the official documentation here
https://supermarket.chef.io/cookbooks/python/versions/1.4.6

- ops-base
Cookbook that install some packages and plugins that will be useful.

- ops-rabbitmq'
Install a configure a rabbitmq server

- ops-route53_autoupdate
Attach the new machine to the DNS.


Those dependencies are add on the Berksfile parent for the download and on the ops-icinga2/metadata.rb file.


## ops-icinga2::default
We use this recipe to call the others.

```
include_recipe "ops-base"
include_recipe "icinga2::client"
include_recipe "icinga2::install"
include_recipe "icinga2::config"
include_recipe "ops-route53_autoupdate"
```

Ops-base is a cookbook that install some packages and plugins that will be useful. Ops-route53_autoupdate update the DNS for each instance.

## ops-icinga2::client

In this recipe we use two dependencies, python and nrpe. Depends on the kind of platform that we are running (rhel or debian) we install different packages for each one.

The recipe use the pip instruction to install nagios and the follows instructions are copy the files on COOKBOOK_NAME/files/default/nagios-plugins-rabbitmq/ to our instance, those files are:

- check_rabbitmq_aliveness
- check_rabbitmq_connections
- check_rabbitmq_objects
- check_rabbitmq_overview
- check_rabbitmq_partition
- check_rabbitmq_queue
- check_rabbitmq_server
- check_rabbitmq_shovels
- check_rabbitmq_watermark

Those files are using to configure plugins to connect Nagios and Rabbitmq. Next, the recipe copy other files on COOKBOOK_NAME/files/default/check-scripts/ to our recipe.

- check_nginx_status.pl
- check_redis.py
- check_redis_key
- pingdom
- rds
- redis_key

This scripts are using for monitoring. They have instructions like calls to pingdom service to tracks the uptime, downtime, and performance of the website or instructions that capture some metrics of our instances. Next we have another script that we copy to our instance to monitoring Apache

The nrpe check instructions, through the value parameters, set and add new actions that will be launched depending on the values in attributes/default.rd file

## ops-icinga2::install

This recipe install and configure Icinga2. Depends on the kind of platform that we are running (rhel or debian) we update diferents repositories for each one, then the recipe install all the packages.

The next templates are using to configure the Icinga2, the conf directory is /etc/icinga2/conf.d

- notifications.conf
- groups.conf
- users.conf
- icinga2.conf

Also we have another template `passwd.erb`, this file contains the http passwords. Next, we create and move the template used in  ops-icinga2::client scripts, like the conf file for pingdom or rds.

When this is done, the recipe start the apache2, npcd, icinga2 and nagios-nrpe-server services.

## ops-icinga2::config

This recipe is use it for install some plugins and additional features to our server. First, we need python so the recipe download and install it. Using the pip instruction we download and install

- icinga-slack-webhook
- nagios-plugin-elasticsearch
- awscli
- boto

The recipe copy to the instance some config files for last packages.
In this recipe we have two cron instructions, the first one is used to execute this recipe every a half hour (1:30, 2:30, 3:30...) and update the values for the Icinga2 server. The second run /etc/icinga2/conf.d/icinga2_opsworks.py, this file search all the instances in the same layer and call to icinga2_config.py on each one who execute the cfg files in the instance and this process is repeat it each hour.

## Attributes

<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
  <td>default["icinga2"]["user"]</td>
  <td>User name for incinga2, nagios by default</td>
  </tr>
  <tr>
  <td>default["icinga2"]["group"]</td>
  <td>Group name for incinga2, nagios by default</td>
  </tr>
  <tr>
  <td>default["icinga2"]["apache_user"]</td>
  <td>Apache username, www-data by default</td>
  </tr>
  <tr>
  <td>default["icinga2"]["apache_group"]</td>
  <td>Apache group name, www-data by default</td>
  </tr>
  <tr>
  <td>default["icinga2"]["conf_dir"]</td>
  <td>Config directoy, all the config files will be here. /etc/icinga2/conf.d by default </td>
  </tr>
  <tr>
  <td>default['icinga2']['server']['packages'] </td>
  <td>Packages names to install</td>
  </tr>
  <tr>
  <td>default['nrpe']['allowed_hosts']</td>
  <td>List of allowed hosts, 127.0.0.1,10.0.0.0/8 by default</td>
  </tr>
  <tr>
  <td>default['nrpe']['install_method']</td>
  <td>Kind of intall method, package by default</td>
  </tr>
  <tr>
  <td>default['nrpe']['plugindir']</td>
  <td>Folder where the nagios plugins will be</td>
  </tr>
  <tr>
  <td>default['icinga2']['check_load']['warning']</td>
  <td>Threshold for a warning</td>
  </tr>
  <tr>
  <td>default['icinga2']['check_load']['critical']</td>
  <td>Threshold for a critical alert</td>
  </tr>
  <tr>
  <td>default['icinga2']['check_ntp_time']['warning']</td>
  <td>Warning condition</td>
  </tr>
  <tr>
  <td>default['icinga2']['check_ntp_time']['critical']</td>
  <td>Critical alert condition</td>
  </tr>
  <tr>
  <td>default['icinga2']['check_ntp_time']['ntp_host']</td>
  <td>ntp host</td>
  </tr>
  <tr>
  <td>default['icinga2']['slack']['channel']['id']</td>
  <td>Name of the slack's channel, #icinga-nclouds for example (nagios notifications)</td>
  </tr>
  <tr>
  <td>default['icinga2']['slack']['domain']</td>
  <td>Domain, nclouds.slack.com for example (nagios notifications)</td>
  </tr>
  <tr>
  <td>default['icinga2']['slack']['token']</td>
  <td>Slack token (nagios notifications)</td>
  </tr>
  <tr>
  <td>default['icinga2']['slack_webhook']['url']</td>
  <td>Slack web hook url (icinga2 notifications)</td>
  </tr>
  <tr>
  <td>default['icinga2']['slack_webhook']['channel']</td>
  <td>Slack channel (icinga2 notifications)</td>
  </tr>
  <tr>
  <td>default['icinga2']['pagerdury']['service_key']['nclouds']</td>
  <td>Key for pagerduty, you can add more variable like this but you need to add it to into the pagerduty-host-notification template</td>
  </tr>
  <tr>
  <td>default['icinga2']['user']['admin']['email']</td>
  <td>admin email</td>
  </tr>
  <tr>
  <td>default['pingdom']['email']</td>
  <td>Pingdom email</td>
  </tr>
  <tr>
  <td>default['pingdom']['pass']</td>
  <td>Pingdom password</td>
  </tr>
  <tr>
  <td>default['pingdom']['api']</td>
  <td>Pingdom api key</td>
  </tr>
  <tr>
  <td>default['icinga2']['rds']['db_identifier']</td>
  <td>RDS identifier</td>
  </tr>
</table>
