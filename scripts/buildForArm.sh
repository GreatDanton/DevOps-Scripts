#!/bin/bash

#########################################################
# This script builds and prepares GO web application
# for distributing on RPI devices (ARM proc)
#########################################################


# exit shell if any command bellow fails
set -e


# --------------------
# Variables
# --------------------

# TODO: Add lines below in function that will build
# software for any architecture in correct folder

# path variables ROOTDIR/SUBDIR
ROOTDIR="build"

# located inside build/
SUBDIR="armBuild"

# name of the final app binary
NAME="analytics"


# --------------------
# SCRIPT
# --------------------

echo ""
echo "*************************************"
echo "* Start building $NAME software"
echo "*************************************"

# set up OS and architecture
env GOOS=linux GOARCH=arm go build -o $NAME src/main.go
echo ""
echo "Code successfully compiled"

# -------------------------------------
# copy all other non go files to build
# -------------------------------------

# if rootdir does not exist, create it
if [ ! -d "$ROOTDIR" ]; then
    echo "Creating $ROOTDIR folder"
    mkdir "$ROOTDIR"
fi

# if subdir does exist remove it and replace it with new files
if [ -d "$ROOTDIR/$SUBDIR" ]; then
    echo "Removing existing files in $SUBDIR"
    rm -r "$ROOTDIR/$SUBDIR"
    mkdir "$ROOTDIR/$SUBDIR"
else
    echo "$ROOTDIR/$SUBDIR folder does not exist, creating new $SUBDIR folder"
    mkdir "$ROOTDIR/$SUBDIR"
fi

# move binary to build folder (we don't need need it in src)
mv "analytics" "$ROOTDIR/$SUBDIR"

# copy public files => js & css & images to build folder
cp -r "src/public" "$ROOTDIR/$SUBDIR/"

# copy templates (.html files)
cp -r "src/templates" "$ROOTDIR/$SUBDIR/"

# -------------------------------------------------------
# FINISHED - inform user
# -------------------------------------------------------

echo "Assets successfully copied"
echo ""
echo "Software is ready to be deployed!"

echo ""
echo "*********************"
echo "*      Success      *"
echo "*********************"
echo ""
