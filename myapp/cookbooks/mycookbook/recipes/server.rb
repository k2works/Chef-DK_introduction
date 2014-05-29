include_recipe "mycookbook"


if node['platform'] == "ubuntu"
  package "git-daemon-run"
else
  package "git-daemon"
end

runit_service "git-daemon" do
  sv_templates false
end
