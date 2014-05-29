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

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

package "git"

log "Well, that was too easy"
