# These should never be set in the cookbook, use an attribute override, etc :)
default['om-env-ogawa']['aws']['access_key_id'] = ''
default['om-env-ogawa']['aws']['secret_access_key'] = ''

# Define a list of packages to install.
default['om-env-ogawa']['base']['packages'] = [
  'vim-nox',
  'tmux',
  'git',
]

# Management subnets to permitt SSH traffic from.
default['om-env-ogawa']['iptables']['management'] = [
  '0.0.0.0/0',
]

# List of ports to permit from all.
default['om-env-ogawa']['iptables']['permit'] = [
  # '5601',
  # '9200',
]

# Ensure correct ruby is used
default['om-env-ogawa']['iptables']['ruby'] = '/opt/chefdk/embedded/bin/ruby'
