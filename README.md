# setup-dump
A place for me to brain-dump my process for creating a LAMP stack for Laravel with Foundation (sass) on a Vagrant machine. All steps (excepting those run in the VM) are run on my Mid 2009 Macbook Pro running (10.11.2).

## The Process
Much of this may not be necessary, as the files will be configured properly in this repo; however, all steps will be documented for repeatability and troubleshooting.

* Initialize the Vagrant box with `vagrant init debian/jessie64`
* Edit Vagrantfile
	* Uncomment `config.vm.network "forwarded_port", guest: 80, host: 8080`
	* Add `config.vm.synced_folder "laravel-project", "/var/www/laravel-project", type: "nfs"` and `config.vm.synced_folder "setup", "/setup", type: "nfs"` (on separate lines) after `# config.vm.synced_folder "../data", "/vagrant_data"`--ensure the path matches the actual location of `setup` and `laravel-project` on your machine
		* If you get an error such as `The host path of the shared folder is missing: setup`, you need to ensure the folder `setup` has been created where you think it should be on your (host) machine
	* Uncomment `# config.vm.network "private_network", ip: "192.168.33.10"`--this is needed for `"nfs"` to work above
* Run `vagrant up`
	* If you run into issues such as `mount.nfs: access denied by server while mounting 192.168.33.1:/path/to/setup-dump/setup`, try running the following (on the host machine): `sudo nfsd checkexports` If there are errors, try editing `/etc/exports` and deleting everything within, then `vagrant destroy -f; vagrant up` should do the trick!
* Create `setup/setup.sh` and `chmod a+x` it--this script will be run on the VM and begin with `sudo apt-get update`
* Install Composer globally `curl -sS https://getcomposer.org/installer | php; mv composer.phar /usr/local/bin/composer`
* Install laravel with `composer global require "laravel/installer"`
* Add `~/.composer/vendor/bin` to `PATH`
	* This may be done by adding (or updating) `~/.profile` and then sourcing it `. ~/.profile` (see sample `.profile` in `misc` folder)
* Create your project with `laravel new laravel-project` (note that this becomes the `laravel-project` that is shared with the VM--if you had already created this empty folder, just delete it and run this command to create it with the new project inside)
*  Within `larvel-project`, install Zurb Foundation with `composer require zurb/foundation`
* Update `setup.sh` to install apache with `sudo apt-get install -y apache2`
* Install nodejs (via installer on their website)
* Remove `"bootstrap-sass": "^3.0.0"` from `package.json` (we'll be using Foundation instead)
* Install sass with `npm install gulp-ruby-sass --save-dev` (this will update your `package.json` as well)
* Run `npm install`
* Create `laravel-project.conf` (use `000-default.conf` in the VM as a template) in `setup/` and update `setup.sh` to copy this file to `/etc/apache2/sites-available/` and `a2ensite` it and `a2dissite` the `000-default.conf` and reload apache.
* Add MySQL installation to `setup.sh` with  `DEBIAN_FRONTEND=noninteractive sudo -E apt-get -q -y install mysql-server` (This will leave root with no password!)
* Add some "secure" stuff for MySQL into `setup.sh` (check on necessity?)
* Add php installation to setup script with `sudo apt-get install -y php5 php-pear`