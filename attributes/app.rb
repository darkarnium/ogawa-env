# Set where to install / extract the ogawa.
default['ogawa']['home'] = '/opt/ogawa'
default['ogawa']['user'] = 'ogawa'

# Set the source git URL.
default['ogawa']['git']['path'] = 'https://github.com/darkarnium/ogawa.git'
default['ogawa']['git']['branch'] = 'develop'

# Set the input and output ARNs / URLs.
default['ogawa']['conf']['bus']['input']['queue'] = 'X'
default['ogawa']['conf']['bus']['output']['elasticsearch'] = 'http://127.0.0.1:9200/sesshu'

# Set the log path.
default['ogawa']['conf']['logging']['path'] = "#{node['ogawa']['home']}/logs/"
