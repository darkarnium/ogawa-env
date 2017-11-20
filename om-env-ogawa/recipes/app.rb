#
# Cookbook Name:: om-env-ogawa
# Recipe:: app
#

# Ensure the app user exists.
user node['om-env-ogawa']['app']['user'] do
  shell '/bin/false'
  home node['om-env-ogawa']['app']['home']
  manage_home false
end

# Fetch and install the ogawa from the given branch - if required.
if node['om-env-ogawa']['app']['git']['use']
  git node['om-env-ogawa']['app']['home'] do
    action :sync
    notifies :run, 'execute[chown-ogawa]', :immediately
    reference node['om-env-ogawa']['app']['git']['branch']
    repository node['om-env-ogawa']['app']['git']['path']
  end

  execute 'chown-ogawa' do
    action :nothing
    notifies :restart, 'service[ogawa]', :delayed
    command [
      'chown -R',
      node['om-env-ogawa']['app']['user'],
      node['om-env-ogawa']['app']['home'],
    ].join(' ')
  end
end

# Create AWS directories.
directory ::File.join(node['om-env-ogawa']['app']['home'], '.aws') do
  owner node['om-env-ogawa']['app']['user']
  group node['om-env-ogawa']['app']['user']
  mode '0700'
  recursive true
  action :create
end

# Create AWS credentials in home.
template ::File.join(node['om-env-ogawa']['app']['home'], '.aws', 'credentials') do
  source 'aws/credentials.erb'
  owner node['om-env-ogawa']['app']['user']
  group node['om-env-ogawa']['app']['user']
  mode '0600'
end

# Create AWS configuration in home.
template ::File.join(node['om-env-ogawa']['app']['home'], '.aws', 'config') do
  source 'aws/config.erb'
  owner node['om-env-ogawa']['app']['user']
  group node['om-env-ogawa']['app']['user']
  mode '0600'
end

# Ensure Python 2 is installed.
python_runtime '2'

# Install required Python modules.
pip_requirements "#{node['om-env-ogawa']['app']['home']}/requirements.txt"

# Write out the correct configuration document for ogawa.
deploy_configuration "#{node['om-env-ogawa']['app']['home']}/conf/ogawa.dist.yaml" do
  destination "#{node['om-env-ogawa']['app']['home']}/conf/ogawa.yaml"
  additions node['om-env-ogawa']['app']['conf']
end

# Provides a reload facility for systemd - which is only invoked via notify
# on unit file installation, change, etc.
execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

# Install the systemd unit file.
template '/etc/systemd/system/ogawa.service' do
  mode 0644
  owner 'root'
  group 'root'
  source 'ogawa.service.erb'
  variables(
    dir: node['om-env-ogawa']['app']['home'],
    user: node['om-env-ogawa']['app']['user'],
    script: "#{node['om-env-ogawa']['app']['home']}/runner.py"
  )
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

# Ensure the service runs on boot, and start it.
service 'ogawa' do
  supports status: true, restart: true
  action [:enable, :start]
end
