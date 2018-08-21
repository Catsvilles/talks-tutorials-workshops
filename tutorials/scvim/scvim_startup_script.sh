#!/bin/bash

# SCVIM STARTUP SCRIPT
# By Mads Kjeldgaard
# --------------------
#
# Usage: bash <path/to/this/script> <optional/path/to/supercollider/file> 
# 
# Example: bash scvim_startup_script.sh cool_project.scd
#
# --------------------
# A startup script for SuperCollider, Vim and TMUX
# This will start a new Tmux session with Vim and the SuperCollider interpreter
# running inside of it.
#
# It will automatically create a .scd buffer with the name of the current date.

# Change this to wherever you have your SuperCollider code saved
# Default is ~/ aka your user directory
SCDIR=${SCDIR:-"~/"}

TMUX=${TMUX:-"tmux"}
SESSION=${SESSION:-"SuperCollider"}

# Check for command line arguments
# First argument of the script is a path to a file
# If the argument is nil, it will create a new file
# in your standard directory defined in SCDIR
if [ -z "$1" ]; 
    then
    # If there is no command line argument passed

    # Concatenate the directory path and the filename of the current file
    FILE=${FILE:-$SCDIR"$(date '+%d%m%Y').scd"}
else
    # If there IS command line argument passed
    FILE=${FILE:-"$1"}
fi

# Start TMUX session with Vim, create a file and execute the SClangStart command
$TMUX attach-session -t $SESSION || $TMUX \
    new-session -s $SESSION   \; \
    send-keys -t 0 "vim $FILE -R" C-m   \; \
    send-keys ":SClangStart" C-m \;
