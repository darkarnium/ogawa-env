#
# Cookbook Name:: ogawa-env
# Recipe:: base
#

# If running under Ubuntu / Debian, ensure apt-get update is run.
case node['platform']
when 'ubuntu', 'debian'
  include_recipe 'apt'
end

# Apply all sysctl values from attributes.
include_recipe 'sysctl::apply'

# Ensure NTP is configured.
include_recipe 'ntp::default'

# Install ulimit configuration.
template '/etc/security/limits.d/base.conf' do
  source 'ulimit-nofile.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Install base system packages.
node['base']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

# Ensure Python is installed.
python_runtime '2'
