#
# Cookbook Name:: ogawa-env
# Recipe:: app
#

# Ensure a user exists.
user node['ogawa']['user'] do
  manage_home false
  shell '/bin/bash'
end

# Fetch and install the ogawa from develop.
git node['ogawa']['home'] do
  action :sync
  notifies :run, 'execute[chown-ogawa]', :immediately
  reference node['ogawa']['git']['branch']
  repository node['ogawa']['git']['path']
end

execute 'chown-ogawa' do
  command "chown -R #{node['ogawa']['user']} #{node['ogawa']['home']}"
  action :nothing
  notifies :restart, 'service[ogawa]', :delayed
end

# Ensure Python 2 is installed.
case node['platform']
when 'ubuntu'
  package 'python' do
    action :install
  end
else
  python_runtime '2'
end

# Install required Python modules.
pip_requirements "#{node['ogawa']['home']}/requirements.txt"

# Write out the correct configuration document for ogawa.
deploy_configuration "#{node['ogawa']['home']}/conf/ogawa.dist.yaml" do
  destination "#{node['ogawa']['home']}/conf/ogawa.yaml"
  additions node['ogawa']['conf']
end

# Provides a reload facility for systemd - which is only invoked via notify
# on unit file installation, change, etc.
execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

# Install the systemd unit file.
template '/etc/systemd/system/ogawa.service' do
  mode 0755
  owner 'root'
  group 'root'
  source 'ogawa.service.erb'
  variables(
    dir: node['ogawa']['home'],
    user: node['ogawa']['user'],
    script: "#{node['ogawa']['home']}/ogawa.py"
  )
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

# Ensure the service runs on boot, and start it.
service 'ogawa' do
  supports status: true, restart: true
  action [:enable, :start]
end
