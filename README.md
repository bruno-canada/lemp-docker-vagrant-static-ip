# Dev environment with LEMP, Redis, and Node based on Vagrant and Docker

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

If you want to keep it as light as possible, I suggest leaving the `vagrant_box` configuration as `generic/alpine312`. Linux Alpine can be 10 times smaller than Ubuntu.

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

## License

This project is licensed under the MIT open source license.
