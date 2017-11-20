# Set where to install / extract the ogawa.
default['om-env-ogawa']['app']['home'] = '/opt/ogawa'
default['om-env-ogawa']['app']['user'] = 'ogawa'

# Set the source git URL.
default['om-env-ogawa']['app']['git']['use'] = true
default['om-env-ogawa']['app']['git']['path'] = 'https://github.com/darkarnium/ogawa.git'
default['om-env-ogawa']['app']['git']['branch'] = 'master'

# Configuration additions.
default['om-env-ogawa']['app']['conf'] = {}
