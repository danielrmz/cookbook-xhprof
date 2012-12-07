#
# Author:: Daniel Ramirez
# Cookbook Name:: xhprof
# Attribute:: default
#
# MIT License
#

default['xhprof']['conf_dir']      = "/etc/php5/cli"
default['xhprof']['ext_conf_dir']  = "/etc/php5/conf.d"
default['xhprof']['target_dir']    = "/apps/utils-xhprof"
default['xhprof']['runs_dir']      = "/var/log/php/xhprof_runs"
default['xhprof']['site_alias']    = "xhprof"
default['xhprof']['domain']        = "localhost"

default['xhprof']['url']           = "https://github.com/facebook/xhprof/tarball/"
default['xhprof']['unzipped_name'] = "facebook-xhprof-b8c76ac"
default['xhprof']['version']       = "b8c76ac5ab005dca507477cc7056d3a9b3c8e7fc"
