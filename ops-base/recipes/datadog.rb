node.override['datadog']['api_key'] = 'c61c9c721bf563960ea049ac14c2e6dc'
node.override['datadog']['application_key'] = 'f4f37bcdc6de7c42ef5e39b9ae993e6b2cf660b7'

include_recipe "datadog::dd-agent"
include_recipe "datadog::dd-handler"