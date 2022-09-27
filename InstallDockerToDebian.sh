#!/usr/bin/env bash

# =============================================================
# Script created date: 03 set 2022
# Created by: Henrique Silva (rick.0x00@gmail.com)
# Name: InstallDockerToDebian
# Description: script to install docker on Debian
# License: MIT
# Remote repository 1: https://github.com/rick0x00/installdockertodebian
# Remote repository 2: https://gitlab.com/rick0x00/installdockertodebian
# =============================================================

underline="________________________________________________________________";
equal="================================================================";
number_sign="################################################################";
plus="++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

# check privileges execution
uid=$(id -u)
if [ $uid -ne 0 ]; then
    echo "Please use sudo or run the script as root."
    exit 1
fi

cd ~

###

uninstall_old_docker(){
    echo "$underline"
    apt list --installed | grep "docker"
    if [ "$?" -eq "0" ]; then
        echo "$plus"
        echo "Uninstall Old Docker"
        echo "$number_sign"
        apt remove docker docker-engine docker.io containerd runc
        if [ "$?" -eq "1" ]; then
            echo "$plus"
            echo "docker is currently installed but will not be uninstalled"
            echo "$plus"
            exit 1;
        fi
    fi
    echo "$underline"
}

install_prerequisites(){
    echo "$underline"
    echo "update system and install Prerequisites"
    echo "$number_sign"
    apt update
    apt install sudo ca-certificates curl gnupg lsb-release
    echo "$underline"
}

SetUpREpository(){
    echo "$underline"
    echo "Set Up the Repository"
    echo "$number_sign"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    echo "$underline"
}

InstallDockerEngine(){
    echo "$underline"
    echo "Install Docker Engine"
    echo "$number_sign"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    apt --fix-broken install
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    echo "$underline"
}

VerifyDockerEngine(){
    echo "$underline"
    echo "Verify Docker Engine is Installed Correctly"
    echo "$number_sign"
    sudo docker run hello-world
    echo "$underline"
}

ManageDockerAsANonRootUser(){
    echo "$underline"
    echo "Manage Docker as a non-root user"
    echo "$number_sign"
    echo "Inform non-root name user manager to docker"
    read USER
    echo "$plus"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo -u sysadmin sh -c "$(newgrp docker & exit)"
    sudo -u sysadmin docker run hello-world
    echo "$number_sign"
}

EnableDockerToStartUp(){
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
}

echo "$equal"
uninstall_old_docker;
install_prerequisites;
SetUpREpository;
InstallDockerEngine;
VerifyDockerEngine;
ManageDockerAsANonRootUser;
EnableDockerToStartUp;
echo "$equal"
