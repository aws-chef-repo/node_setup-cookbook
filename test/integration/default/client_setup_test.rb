# InSpec test for recipe node_setup::client_setup.rb

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe file('/etc/chef/client.rb') do
  it { should exist }
end

describe file('/etc/chef/validation.pem') do
  it { should_not exist }
end

describe file('/etc/chef/client.rb') do
  its('content') { should match /chef_license "accept"/ }
  its('content') { should match /chef_server_url/ }
  its('content') { should match /policy_group "staging"/ }
  its('content') { should match /policy_name "web-server"/ }
  its('content') { should match /log_location STDOUT/ }
  its('content') { should match %r{validation_client_name "aws-org-validator"} }
  its('content') { should match %r{trusted_certs_dir "/etc/chef/trusted_certs"} }
end

describe crontab(path: '/etc/cron.d/chef-client') do
  its('entries.length') { should cmp 1 }
  its('hours') { should cmp '*' }
  its('minutes') { should cmp '0,30' }
  its('days') { should cmp '*' }
  its('months') { should cmp '*' }
end
