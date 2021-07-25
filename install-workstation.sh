#!/bin/bash
#
# Workstation installer script for the Latest fedora (29).
#
# D250 Laboratories / D250.hu 2014-2019
# Author: István király
# LaKing@D250.hu
# 
## download, update with:
# curl http://d250.hu/scripts/install-workstation.sh > install.sh 
## run with bash 
# && bash install.sh
#

## Timestamp
readonly NOW="$(date +%Y.%m.%d-%H:%M:%S)"
## logfile
readonly LOG="$(pwd)/install-workstation.log"
## current dir
readonly DIR="$(pwd)"
## temporal backup and work directory
readonly TMP="/temp"
## A general message string 
readonly MSG="## D250 Laboratories $0 @ $NOW"
## Debugging helper
DEBUG=false
## constants
ARG="$1"

## constants for use everywhere
readonly RED='\e[31m'
readonly GREEN='\e[32m'
readonly YELLOW='\e[33m'
readonly BLUE='\e[34m'
readonly GRAY='\e[37m'
readonly CLEAR='\e[0m'

## Lablib functions

function msg {
    ## message for the user
    echo -e "${GREEN}$*${CLEAR}"
}

function ntc {
    ## notice for the user
    echo -e "${YELLOW}$*${CLEAR}"
}


function log {
    ## create a log entry
    echo -e "${YELLOW}$1${CLEAR}"
    echo "$NOW: $*" >> "$LOG"
}

## silent log
function logs {
    ## create a log entry
    echo "$NOW: $*" >> "$LOG"
}
dbgc=0
function dbg {
    ((dbgc++))
    ## short debug message if debugging is on
    if $DEBUG
    then
        echo -e "${YELLOW}DEBUG #$dbgc ${BASH_SOURCE[1]}#$BASH_LINENO ${FUNCNAME[1]} ${RED} $* ${CLEAR}"
    fi
}
function debug {
    ## tracing debug message
    echo -e "${YELLOW}DEBUG ${BASH_SOURCE[1]}#$BASH_LINENO ${FUNCNAME[1]} ${RED} $*${CLEAR}"
}
function err {
    ## error message
    echo -e "$NOW ERROR ${RED}$*${CLEAR}" >> "$LOG"
    echo -e "${RED}$*${CLEAR}" >&2
}

function run {
    local signum='$'
    if [ "$USER" == root ]
    then
        signum='#'
    fi
    local WDIR
    WDIR="$(basename "$PWD")"
    echo -e "${BLUE}[$USER@${HOSTNAME%%.*} ${WDIR/#$HOME/\~}]$signum ${YELLOW}$*${CLEAR}"

    # shellcheck disable=SC2048
    $*
    eyif "command '$*' returned with an error"
}

## exit if failed
function exif {
    local exif_code="$?"
    if [ "$exif_code" != "0" ]
    then
        if $DEBUG
        then
            ## the first in stack is what we are looking for. (0th is this function itself)
            err "ERROR $exif_code @ ${BASH_SOURCE[1]}#$BASH_LINENO ${FUNCNAME[1]} :: $*"
        else
            err "$*"
        fi
        exit "$exif_code";
    fi
}

## extra yell if failed
function eyif {
    local eyif_code="$?"
    if [ "$eyif_code" != "0" ]
    then
        if $DEBUG
        then
            err "ERROR $eyif_code @ ${BASH_SOURCE[1]}#$BASH_LINENO ${FUNCNAME[1]} :: $*"
        else
            err "$*"
        fi
    fi
}


## If user is root or runs on root privileges, continiue.
if [ "$UID" -ne "0" ]
then
  ntc "Root privileges needed to run this script. Trying with sudo."
  ## Attemt to get root privileges with sudo, and run the script
  sudo bash "$0" "$1"
  exit
fi

## Any enemy in sight? :)
clear

if [[ $SUDO_USER ]]
then
     ## calling user is a sudoer
     USER="$SUDO_USER"
else
     ## user must be root, and a default user is needed
     USER="$(getent passwd 1000 | cut -d: -f1)"
fi

## Author info
# echo "István Király - D250 Laboratories. LaKing@D250.hu"

## Version info
ntc "$(cat /etc/fedora-release) detected!"

USER_HOME="$( getent passwd "$USER" | cut -d: -f6 )"


if [ -z "$USER" ]
then 
    err "No user could be located." 
    exit
else
    log "Started with user: $USER - home in $USER_HOME"
fi

msg "$MSG"
mkdir -p "$TMP"


log "Questioning Installation started."

a=0
n=0
h=0

## Basic helper functions
function question {
    ## Add to the question que asq, with counter a

    (( a++ ))
    asq[$a]=$1
    hlp[$a]=$2
    def[$a]=$3
}


function question_que {
    ## run the question que. Default answer is no, y is the only other option
    ## y-answered question are added to the executation que
    echo ''
    echo "${hlp[h]}"

    key=
    echo -n "$1? " | tr '_' ' '

    default_key=${def[h]:0:1}
    default_str="y/N"

    if [[ $default_key == y* ]]; then
      default_str="Y/n"
    else
      default_str="y/N"
    fi
     # shellcheck disable=SC2034
    read -s -r -p " [$default_str] " -n 1 -i "y" key

    ## Check for default action
    if [ ${#key} -eq 0 ]; then
     ## Enter was hit"
     key=$default_key
    fi

    ## Make it an ordenary string
    if [[ $key == y ]]; then
     key="yes"
    else
     key="no";
    fi

    echo $key

    ## Que the action if yes
    if [[ $key == y* ]]; then
      echo "$1" >> "$LOG"
      (( n++ ))
      que[$n]=$1 
    fi
}

function bak {
    ## create a backup of the file, with the same name, same location .bak extension
    ## filename=$1
    echo "$MSG" >> "$1.bak"
    cat "$1" >> "$1.bak"
    #echo "$1 has a .bak file"
}

function set_file {
    ## cerate a file with the content overwriting everything
    ## filename=$1 content=$2

    if [[ -f $1 ]]
    then 
          bak "$1"
    fi
    echo "creating $1"
    echo "$2" > "$1"
}

function sed_file {
    ## used to replace a line in a file
    ## filename=$1 old line=$2 new line=$3
    bak "$1"
    cat "$1" > "$1.tmp"
    sed "s|$2|$3|" "$1.tmp" > "$1"
    rm "$1.tmp"
}

function add_conf {
    ## check if the content string is present, and add if necessery. Single-line content only.
    ## filename=$1 content=$2

    if [[ -f $1 ]]
    then 
          bak "$1"
    fi

    if grep -q "$2" "$1"
    then
     echo "$1 already has $2"
    else
     echo "adding $2"
     echo "$2" >> "$1"
    fi
}



function finalize {
## run the que's, and do the job's. This is the main function.
  msg "=== Confirmation for ${#asq[*]} commands. [Ctrl-C to abort] ==="
  for item in ${asq[*]}
  do
    (( h++ ))
    question_que "$item" #?
  done

  msg "=== Running the Que of ${#que[*]} commands. ==="
  for item in ${que[*]}
  do
    msg "== $item started! =="
    ntc "$item"
    $item
    msg "== $item finished =="
  done

  msg "=== Post-processing tasks ===";
  for item in ${que[*]}
  do
    if [ "$item" == "install_and_finetune_gnome_desktop" ] 
    then
     # run this graphical tool at the end
     if [ -z "$USER" ]; then echo "No user to tune gnome, skipping question." >> "$LOG"; else
        ntc "Starting the gnome Tweak tool."
        su "$USER" -c gnome-tweaks
     fi
    fi 
  done
  echo "Finished. $MSG" >> "$LOG"
}

## NOTE: question / function should have a consistent name, .. that's all.
for f in */*.sh
do
	source "$f"
done

#if [[ $# -eq 0 ]]
#then
#
#fi

## Finalize will do the whole job.	
if [[ $ARG == '' ]]
then
	finalize
	exit	
else
	$ARG
fi




