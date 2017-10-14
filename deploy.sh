#!/bin/bash

####################################################################
# This script executes build and push scripts
# => one click to deploy software to server
####################################################################

/bin/bash ./buildForArm.sh
echo "Pushing to server:"
/bin/bash ./pushToServer.sh