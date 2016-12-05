# Force a compile-time update of apt.
override['apt']['compile_time_update'] = true

# Define a list of packages to install.
default['base']['packages'] = [
  'vim-nox',
  'tmux',
  'git'
]
