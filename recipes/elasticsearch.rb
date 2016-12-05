#
# Cookbook Name:: ogawa-env
# Recipe:: elasticsearch
#

include_recipe 'java::default'

# Install and configure ElasticSearch.
elasticsearch_install 'elasticsearch' do
  type 'repository'
  action :install
  version node['es']['version']
end

elasticsearch_user 'elasticsearch'

elasticsearch_configure 'elasticsearch' do
  allocated_memory node['es']['memory']
end

elasticsearch_service 'elasticsearch' do
  service_actions [:enable, :start]
end

# Install Kibana (from the ElasticSearch repository).
package 'kibana' do
  action :install
end

service 'kibana' do
  supports status: true
  action [:enable, :start]
end

template '/etc/kibana/kibana.yml' do
  source 'kibana.yml.erb'
  owner 'root'
  group 'root'
  mode 00744
end
