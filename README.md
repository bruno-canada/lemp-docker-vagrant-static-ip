# Dev env with LEMP, Composer, Redis, and Node based on Vagrant and Docker

This setup offers cross-platform compatibility, static IP without port conflicts, custom hostname (dev.mysite.com), and a fully centralized config file.

## Requirements
- VirtualBox `>= v5.0`
    - VirtualBox is a hypervisor where you can manage virtual machines running any operational system (OS).
    - https://www.virtualbox.org/wiki/Downloads
- Vagrant `>= v2.1.0`
    - Automation software to create a workflow and build development environments based on a hypervisor.
    - https://www.vagrantup.com/downloads

That's all. You do not need to have Docker nor any other software locally. It will be properly installed inside the VM.

## How to use it

### 1. Get the files

You can either clone this repository or download the files to use with your development project.

- Clone option:
```
git clone git@github.com:bruno-canada/lemp-docker-vagrant-static-ip.git
```

- Download option:
    - Access: https://github.com/bruno-canada/lemp-docker-vagrant-static-ip/archive/main.zip

### 2. Adjust the configs

Everything you need to change is centralized inside of `dev-config.yml`, all the other tools will read information from it, including Vagrant, Docker, PHP, NGINX, MySQL...

The default Vagrant box used in my `dev-config.yml` file is a minimalist Alpine Linux v3.12 with Docker and Docker compose already installed, the box is `bruno-canada/alpine312-docker`.

If you decide to change the Vagrant box make sure to edit the file `provision/base-packages.sh` to uncomment the base packages.

### 3. Boot up the environment

From inside the same directory where the file `Vagrant` is run: `vagrant up`

After it completes, you can access the hostname you have defined inside the configuration file from your browser. e.g. lemp-docker-vagrant-static-ip.com

## Cheatsheet

- Access the virtual machine (VM) SSH: `vagrant ssh`

- Delete (permanently) the VM: `vagrant -D destroy`

- Run provisioning tasks: `vagrant provision`

- Restart Docker daemon from inside the VM (Running Linux Alpine): `sudo rc-service docker restart`

- Stop/Start/Restart Docker compose containers. (From inside the VM and the project folder)
```
docker-compose start
docker-compose stop
docker-compose restart
```

- Delete Docker containers, networks, volumes, and images created by Docker compose for this setup: `docker-compose down`

- Builds, (re)creates, starts, and attaches to containers for service in detached mode. (Run containers in the background): `docker-compose up -d`

- List running Docker compose containers: `docker-compose ps`

- Running NPM commands via container: `docker-compose run npm install`

- Running Composer commands via container: `docker-compose run composer install`

## Tips and tricks

- Suppressing prompts for elevating privileges (Linux, macOS, or Windows)
    - Check: https://github.com/agiledivider/vagrant-hostsupdater#suppressing-prompts-for-elevating-privileges

- Trust self-signed certificate on macOS:
    1. Open project folder in Finder and open .crt file inside Keychain Access
        - The certificate file will be placed automatically inside your project folder after `vagrant up`
    2. Click on 'Certificates' under 'Category'
    3. Open certificate info window and select 'Always Trust'
    4. Back in Finder, remove the .crt file
    
- Trust self-signed certificate on Windows via Google Chrome:
    1. On Google Chrome type chrome://settings/security?search=security
    2. Click on Manage Certificates
    3. Click on Import
    4. Select the `*.crt` file and import it to `Trusted Root Certification Authorities`
        - The certificate file will be placed automatically inside your project folder after `vagrant up`
    5. Back to Chrome type chrome://restart
    6. Delete the .crt file

## License

This project is licensed under the MIT open source license.
