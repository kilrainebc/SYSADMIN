#! /bin/bash

#===================================================================================
#
# FILE: snd.sh
#
# USAGE: ./snd.sh -p </path/to/file> -l </path/to/list/> [-s | w | d]
#
# DESCRIPTION: "Search & Destroy" script; allows administrators easily search for
#               and/or remove certain files across multiple servers.
#
# OPTIONS: -p: Path to file.  e.g.: /tmp/textfile.txt; /var/log/*.log
#          -l: List filename from directory above script pwd
#          -s: Regular search mode, on by default
#          -w: Wildcard mode; Can be set manually, or script can auto-detect
#          -d: Delete mode.
#
# AUTHOR:  Blake Kilraine
# COMPANY: [redacted]
# VERSION: 1.0
# CREATED: 2/6/2018
# REVISION: 1.a
#===================================================================================

#============================ VARIABLES & OPTIONS  =================================

while getopts ":p:l:swd" opt; do
  case $opt in
    p)
      echo "Path: $OPTARG" >&2
      PTF=$OPTARG
      DIR=`dirname "$PTF"/`
      EXP=`basename "$PTF"`
      ;;
    l)
      echo "List: $OPTARG" >&2
      LIST=`ls ../$OPTARG`
      ;;
    s)
      echo "Search Chosen"
      FCN=Search
      ;;
    w)
      echo "Wildcard Search Chosen"
      FCN=WCard
      ;;
    d)
      echo "Destroy Chosen"
      FCN=Destroy
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

#============================ FUNCTIONS ==============================================

#=== FUNCTION ================================================================
# EXP: Search
# DESCRIPTION: Searches for $4 in $server:${3} and reports back.
#=============================================================================

Search () {
  echo ATTENTION: "${PTF}"  is the searched for file
  for server in `cat  $LIST | grep -v ^#`                                                  # For each entry in $list that doesn't begin with "#"...
do                                                                                         # Do
  echo
  serverIP=$(nslookup $server | tail -2 | awk -F ":" '{print $2}')                         ### Translates hostname into IPv4 address
  RESULT=$(ssh -q $serverIP "find "${DIR}" -name '"${EXP}"'")                           ### Grabs result from "find $DIR -name $EXP" command
  echo
  echo "----------------------< $server | $serverIP  >----------------------"
  if [[ $RESULT = "${PTF}" ]]                                              ### Compares $RESULT with the full search parameters
    then
    printf "The Result exits!!!" >&2
    else
    printf "Result not found" >&2
  fi
  echo
  echo "--------------------------------------------------------------------"
  echo
  done
}

#=== FUNCTION ================================================================
# EXP: WCard
# DESCRIPTION: Searches for $4 in $server:${3} and displays whatever matches $4's Wildcard
#=============================================================================

WCard () {
  echo ATTENTION: "${PTF}"  is the search parameter
  if [[ ${EXP} = all ]]
    then
    printf "Name Parameter is '*'; changing from all to "*"" >2&
    EXP="*"
    else
    echo
  fi

  for server in `cat  $LIST | grep -v ^#`                                                  # For each entry in $list that doesn't begin with "#"...
do                                                                                         # Do
  echo
  serverIP=$(nslookup $server | tail -2 | awk -F ":" '{print $2}')                         ### Translates hostname into IPv4 address
  echo
  RESULT=$(ssh -q $serverIP "find "${DIR}" -name  '"${EXP}"'")                             ### Grabs result from "find $DIR -name $EXP" command
  echo
  echo
  echo "----------------------< $server | $serverIP  >----------------------"
  if [[ $RESULT = "" ]]
    then
    printf "Result not found"
    else
    printf "Here are the results...:"
    echo
    echo "$RESULT"
    echo
  fi
  echo
  echo "--------------------------------------------------------------------"
  echo
  done
}

#=== FUNCTION ================================================================
# EXP: Destroy
# DESCRIPTION: Searches for $4 in $server:${3}.  If file is found, it rm's it.  Use cautiously!!!
#=============================================================================

Destroy () {
  echo ### ATTENTION ### SCRIPT SET TO DELETE MODE - ARE YOU 100% CERTAIN?
  echo
  read -r -p "Are you sure? [y/N] " response                                              #Requires response to continue forward in function
  case "$response" in
    [yY][eE][sS]|[yY])
        echo "Proceeding..."
        ;;
    *)
        exit
        ;;
  esac

  read -r -p "Are you REALLY sure? [y/N] " response2
  case "$response2" in
    [yY][eE][sS]|[yY])
        echo "!!! ENTERING DELETE MODE!  BE CAREFUL !!!"
        ;;
    *)
        exit
        ;;
  esac

  for server in `cat  $LIST | grep -v ^#`                                                  # For each entry in $list that doesn't begin with "#"...
do                                                                                         # Do
  echo
  serverIP=$(nslookup $server | tail -2 | awk -F ":" '{print $2}')                         ### Translates hostname into IPv4 address
  RESULT=$(ssh -q $serverIP "find "${DIR}" -name '"${EXP}"'")                              ### Grabs result from "find $DIR -name $EXP" command
  echo "----------------------< $server | $serverIP  >----------------------"
  ssh -q $serverIP "rm -i ${PTF}"                                                          ### removes the file(s).  Interactive, and non recursive.
  echo
  echo "--------------------------------------------------------------------"
  echo
  done
}

#========================== SCRIPT  ==========================================

if [[ $# -lt 4 ]]                # Tests if parameter was used.
    then
    printf "Usage: %s ./snd.sh <LIST> <FCN> <DIR> <EXP> ; Edit and read comments if unsure \n" "$(basename "$0")" >&2
    exit 64
    else
    echo
    echo "Starting Script"
    echo
fi

if echo "$FCN" | grep "Destroy" > /dev/null     # Tests for destroy.  If destroy not set, parses for "*" and sets to wildcard.
  then
  FTC="Destroy"
  else
    if echo "$EXP" | grep '*' > /dev/null
    then
    FCN="WCard"
    echo "Function changed to Wildcard because '*' was detected in Name Parameter"
    fi
fi

echo
echo "------------------< $FCN is now starting >---------------------------"
echo
$FCN                                                                             #invokes the wanted function.
exit
