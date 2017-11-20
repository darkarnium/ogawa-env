#
# Cookbook Name:: om-env-ogawa
# Recipe:: default
#

include_recipe 'om-env-ogawa::base'
include_recipe 'om-env-ogawa::elasticsearch'
include_recipe 'om-env-ogawa::app'
