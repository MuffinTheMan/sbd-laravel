# Setup Brain-Dump - Laravel
A place for me to brain-dump my process for creating a LAMP stack for Laravel with Foundation (sass) on a Vagrant machine. All steps (excepting those run in the VM) are run on my Mid 2009 Macbook Pro running (10.11.2).

## How to Use
So, you want to utilize this repo to help you get started even quicker with Laravel and Foundation? Great--follow the below steps to get started!

1. Clone the repository `git clone https://github.com/MuffinTheMan/sbd-laravel.git`
	* If you are planning on working on this project (i.e. not using this to build a new site), discontinue this "How to Use" guide; otherwise, continue
2. Rename the repository to something that makes sense for your site `mv sbd-laravel my-site`
3. Stop tracking the `sbd-laravel` repo with `cd sbd-laravel && rm -rf .git`
4. If you want to use git, run `git init` (or `git-flow init` if you're a git-flow person)
5. In the `laravel-project` directory run `composer install` (or `php composer.phar install`) and `npm install`
	* Note: you could rename the `laravel-project` directory as well, just be aware that you would also have to update `setup.sh` and `laravel-project.conf` to make sure everything matches
5. Back in the main directory, you're now ready to use this project to setup your environment, run `vagrant up` to get the VM going
6. Once complete, `vagrant ssh`, then `cd /setup && ./setup.sh`. This will take a little while, but once it's done, you'll have a LAMP stack and a working Laravel site that can be viewed at `localhost:8080`

## The Process
Here is the process--brain-dumped. This is for troubleshooting, etc. Follow the "How to Use" guide for, well, how to use it :)

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
* Update `resources/assets/sass/app.scss` to `@import "foundation.scss";` and `@include foundation-everything` in order to use all of Foundation
* Update `gulpfile.js` to `mix.sass('app.scss', null, {includePaths: ["vendor/zurb/foundation/scss"]});`
* Update `gulpfile.js` to include a versioning function and add comment regarding minification (`gulp --production`)