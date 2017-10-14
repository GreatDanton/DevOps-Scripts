#!/bin/bash

########################################################################
# This script takes care of deploying application to server
# -> fill in the variables and enjoy in automated deployment
#
# Make sure you deployed your ssh keys to server, and added your
# 'deployer' user into sudoers directory (see below how to do that)
########################################################################


# exit shell if any command bellow fails
set -e


# -----------------
# Variables
# -----------------

# ssh port
SSH_PORT="1234"

# ip of our server
SERVER_IP="192.168.1.10"

# name of the deploying user -> make sure his commands are in sudoers file
# /etc/sudoers.d/deployer
#
# example of such file:
# %deployer ALL=NOPASSWD: /bin/systemctl start mxapp.service
# %deployer ALL=NOPASSWD: /bin/systemctl start mxapp.service
DEPLOYER="deployer"

# user where the files will be located
APP_USER="appUser"

# name of the systemctl server
SERVICE="appName.service"

# output server directory -> we are copying app files here
SERVER_DIR="~/appName/"

# local directory where the built files are located
LOCAL_DIR="build/armBuild"


# ----------------------------------------------------------------------
# Actual script begins here:
# ----------------------------------------------------------------------

#-----------------------
# stop service
#-----------------------
# First we have to stop the executing service otherwise, we can't rsyinc
# new binary over the old one
#
# user: deployer must be in sudoers file
ssh -p "$SSH_PORT" "$DEPLOYER@$SERVER_IP" "sudo systemctl stop $SERVICE"
echo "Service stopped"

#-----------------------
# deploy application
#-----------------------
# -a archive(preserve symbolic links, modification times)
# -z compression
# -P progress
# -e "ssh -p $PORT" -> use rsync on different port
# --dry-run -> test run your script
# --delete unused missing files
# --exclude -> exclude config.json from deleting on server
rsync -aP -e "ssh -p $SSH_PORT" --delete --exclude "config.json" "$LOCAL_DIR" "$APP_USER@$SERVER_IP:$SERVER_DIR"
echo "Files deployed successfully"


#-----------------------
# start service
#-----------------------
# start our service after deploy
ssh -p "$SSH_PORT" "$DEPLOYER@$SERVER_IP" "sudo systemctl start $SERVICE"
echo "Service $SERVICE started"


echo ""
echo "*****************************"
echo "*   Deployed Successfully   *"
echo "*****************************"
echo ""