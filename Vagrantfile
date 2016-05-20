$enable_serial_logging = false

Vagrant.configure(2) do |config|

  config.vm.box = "bento/ubuntu-14.04"

  config.ssh.forward_agent = true
  config.vm.hostname = "apdevbox"
  config.vm.network "private_network", ip: "192.168.44.44", :netmask => "255.255.255.0"

  config.vm.synced_folder "repos", "/home/vagrant/repos"

  # workaround for vagrant 1.7.2 bug
  # https://github.com/mitchellh/vagrant/issues/5199
  config.trigger.after [:suspend, :halt], stdout: true do 
    if File.exist?(".vagrant/machines/default/virtualbox/synced_folders")
      `rm .vagrant/machines/default/virtualbox/synced_folders`
    end

    if File.exist?(".vagrant/machines/default/vmware_fusion/synced_folders")
      `rm .vagrant/machines/default/vmware_fusion/synced_folders`
    end
  end

  config.trigger.before [:reload], stdout: true do 
    if File.exist?(".vagrant/machines/default/virtualbox/synced_folders")
      `rm .vagrant/machines/default/virtualbox/synced_folders`
    end

    if File.exist?(".vagrant/machines/default/vmware_fusion/synced_folders")
      `rm .vagrant/machines/default/vmware_fusion/synced_folders`
    end
  end

  config.vm.provider "vmware_fusion" do |vm|
    vm.vmx["memsize"] = "512"
    vm.vmx["numvcpus"] = "1"
  end

  config.vm.provider "virtualbox" do |vm|
    vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/repos", "1"]
    vm.customize ["modifyvm", :id, "--memory", "512"]
    vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # http://jeremykendall.net/2014/10/06/forcing-an-ntp-update/
    vm.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

  config.omnibus.chef_version = :latest
  config.cache.scope = :box
  config.berkshelf.enabled = true

  config.vm.provision "base", type: "chef_solo" do |chef|
    chef.add_recipe "default::ssh"
    chef.add_recipe "git"
  end

  # Check if ~/.gitconfig exists locally
  # If so, copy basic Git Config settings to Vagrant VM
  if File.exists?(File.join(Dir.home, ".gitconfig"))
    git_name = `git config user.name`   # find locally set git name
    git_email = `git config user.email` # find locally set git email
    # set git name for 'vagrant' user on VM
    config.vm.provision :shell, :inline => "echo 'Saving local git username to VM...' && sudo -i -u vagrant git config --global user.name '#{git_name.chomp}'"
    # set git email for 'vagrant' user on VM
    config.vm.provision :shell, :inline => "echo 'Saving local git email to VM...' && sudo -i -u vagrant git config --global user.email '#{git_email.chomp}'"
  end

  config.vm.provision "bootstrap", type: "shell" do |s|
    s.inline = %{
      gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
      curl -L https://get.rvm.io | bash -s stable --ruby
      apt-get install -y python-pip
      pip install awscli
    }
  end

  config.vm.provision "apdevblog", type: "chef_solo" do |chef|
    chef.add_recipe "default::timezone"
    chef.add_recipe "default::repo"
  end

end
