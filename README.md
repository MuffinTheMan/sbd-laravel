# setup-dump
A place for me to brain-dump my process for creating a LAMP stack for Laravel with Foundation (sass) on a Vagrant machine. All steps (excepting those run in the VM) are run on my Mid 2009 Macbook Pro running (10.11.2).

## The Process
Much of this may not be necessary, as the files will be configured properly in this repo (such steps will be followed by (^_^)); however, all steps will be documented for repeatability and troubleshooting.

* Initialize the Vagrant box with `vagrant init debian/jessie64` (^_^)
* Edit Vagrantfile (^_^)
	* Uncomment `config.vm.network "forwarded_port", guest: 80, host: 8080`
	* Add `config.vm.synced_folder "laravel-project", "/var/www/laravel-project", type: "nfs"` and `config.vm.synced_folder "setup", "/setup", type: "nfs"` (on separate lines) after `# config.vm.synced_folder "../data", "/vagrant_data"`--ensure the path matches the actual location of `setup` and `laravel-project` on your machine
		* If you get an error such as `The host path of the shared folder is missing: setup`, you need to ensure the folder `setup` has been created where you think it should be on your (host) machine
	* Uncomment `# config.vm.network "private_network", ip: "192.168.33.10"`--this is needed for `"nfs"` to work above
* Run `vagrant up`
	* If you run into issues such as `mount.nfs: access denied by server while mounting 192.168.33.1:/path/to/setup-dump/setup`, try running the following (on the host machine): `sudo nfsd checkexports` If there are errors, try editing `/etc/exports` and deleting everything within, then `vagrant destroy -f; vagrant up` should do the trick!
* Create `setup/setup.sh` and `chmod a+x` it--this script will be run on the VM