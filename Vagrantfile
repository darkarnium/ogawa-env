VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.hostname = 'ogawa-dev'

  config.berkshelf.enabled = true
  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = 'latest'
  end

  config.vm.synced_folder '../ogawa', '/opt/ogawa'

  config.vm.network :private_network, type: 'dhcp'
  config.vm.network 'forwarded_port', guest: 5601, host: 5601
  config.vm.network 'forwarded_port', guest: 9200, host: 9200

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
  end

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      'recipe[ogawa-env::base]',
      'recipe[ogawa-env::elasticsearch]',
      'recipe[ogawa-env::app]'
    ]
  end
end
