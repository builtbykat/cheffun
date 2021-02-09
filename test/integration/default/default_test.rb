# InSpec test for recipe lamp::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

packages = ['apache2', 'php-mysql', 'php']

packages.each do |pkg|
	describe package(pkg) do
		it { should be_installed }
	end
end

describe file('/etc/apache2/sites-available/000-default.conf') do
	it { should exist }
	its('owner') { should eq 'www-data' }
	its('group') { should eq 'www-data' }
	its('mode') { should cmp '0644' }
	its(:content) { should include 'DirectoryIndex index.php' }
	its(:content) { should include 'AllowOverride All' }
	its(:content) { should include 'Require all granted' }
end

describe file('/var/www/sandbox/index.php') do
	it { should exist }
	its('owner') { should eq 'www-data' }
	its('group') { should eq 'www-data' }
	its('mode') { should cmp '0644' }
	its(:content) { should include 'The time where Josh lives: ' }
end

describe http('http://localhost') do
	its('status') { should cmp 200 }
	its('body') { should include 'The time where Josh lives: ' }
end