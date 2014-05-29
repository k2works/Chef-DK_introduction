#
# Cookbook Name::
# Recipe:: default
#
# Copyright (C) 2014
#
#
#
bash 'bootstrap' do
  code <<-EOC
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
  EOC
end

execute "update-pkg" do
  if node['platform'] == "ubuntu"
    command "apt-get update -y"
  else
    command "yum update -y"
  end
end

if node['platform'] == "ubuntu" && node['platform_version'].to_f <= 10.04
  package "git-core"
else
  package "git"
end

log "Well, that was too easy"
