 #
# Cookbook Name:: xhprof
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_recipe "php::source" 
require_recipe "apache2"

package "graphviz" do 
	action :install
end

xhprof_srcurl = "#{node['xhprof']['url']}#{node['xhprof']['version']}"

remote_file "#{Chef::Config[:file_cache_path]}/xhprof-#{node['xhprof']['version']}.tar.gz" do
  source xhprof_srcurl 
  mode "0644"
end

bash "Build xhprof" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
# Download and Compile xhprof
  tar -xvzf xhprof-#{node['xhprof']['version']}.tar.gz
  (cd #{node['xhprof']['unzipped_name']}/extension && phpize)
  (cd #{node['xhprof']['unzipped_name']}/extension && ./configure)
  (cd #{node['xhprof']['unzipped_name']}/extension && make)
  (cd #{node['xhprof']['unzipped_name']}/extension && make install)
  (cd #{node['xhprof']['unzipped_name']}/extension && make test)
  
# Create Runs result directory
  mkdir -p #{node['xhprof']['runs_dir']}

# Add the ini file  
  echo "[xhprof]" > #{node['xhprof']['ext_conf_dir']}/xhprof.ini
  echo "extension=xhprof.so" >> #{node['xhprof']['ext_conf_dir']}/xhprof.ini
  echo "xhprof.output_dir=#{node['xhprof']['runs_dir']}" >> #{node['xhprof']['ext_conf_dir']}/xhprof.ini

# Move the UI dirs
  mkdir -p #{node['xhprof']['target_dir']}
  mv #{node['xhprof']['unzipped_name']}/xhprof_lib #{node['xhprof']['target_dir']}/xhprof_lib
  mv #{node['xhprof']['unzipped_name']}/xhprof_html #{node['xhprof']['target_dir']}/xhprof_html
  
  EOF
end

directory node['xhprof']['target_dir'] do
	owner "root"
	group "root"
	mode "0755"
	recursive true
end

directory node['xhprof']['runs_dir'] do
	owner "root"
	group "root"
	mode "0777"
	recursive true
end

template "/etc/apache2/sites-enabled/zzz-xhprof" do
  source "xhprof-ui.conf.erb"
  mode "0660"
  variables(:docroot => node['xhprof']['target_dir'] + '/xhprof_html')
end


bash "Restart services" do
	notifies :restart, resources("service[apache2]"), :delayed	
	
	not_if "echo 'OK'"
end



