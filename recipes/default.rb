#
# Cookbook:: lamp
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

packages = ['apache2', 'php-mysql', 'php']

# install packages
packages.each do |package|
	apt_package package do
		action :install
	end
end

# create service resource so that apache restarts
service 'apache2' do
	action [ :enable, :start ]
end

# attribute definition to specify our doc_root
node.default['sandbox']['doc_root'] = '/var/www/sandbox' # i believe this is a global var rather than a local one

# create our doc_root
directory node['sandbox']['doc_root'] do
	action :create
end

template 'etc/apache2/sites-available/000-default.conf' do
	source 'vhost.erb'
	variables({ :doc_root => node['sandbox']['doc_root'] }) # set our @doc_root var in the template
	owner 'www-data'
	group 'www-data'
	mode '0644'
	action :create
	notifies :restart, resources(:service => 'apache2') # call our service resource created earlier
end
