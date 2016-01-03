git "/home/vagrant/repos/apdevblog.com" do
  repository "git@github.com:apdev/apdevblog.com.git"
  enable_checkout false
  checkout_branch "master"
  user "vagrant"
  group "vagrant"
  action :sync
  not_if {::File.exists?("/home/vagrant/repos/apdevblog.com")}
end

execute "bundle" do
  cwd "/home/vagrant/repos/apdevblog.com"
  command "bundle install"
  environment ({"HOME" => "/home/vagrant"})
end
