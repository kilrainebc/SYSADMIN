#! /bin/bash

#===================================================================================
#
# FILE: systems.sh
#
# USAGE: ./systems.sh <List file from directory above>
#
# DESCRIPTION: Simple script which pulls information from servers.
#
# OPTIONS: ---
# REQUIREMENTS: ---
# BUGS:
# NOTES:
# AUTHOR:  Blake Kilraine
# COMPANY: [redacted]
# VERSION: 1.0
# CREATED: 1-29-2018
# REVISION:
#===================================================================================

#============================ VARIABLES ==============================================

list=`ls ../$1` #Sets $list variable to parameter 1; should be a list of hostnames.

#============================ FUNCTIONS ==============================================

#=== FUNCTION ================================================================
# NAME: BasicInfo
# DESCRIPTION: Gathers RHEL version, Kernel version, and IPv4 address.
#               from each server in designated list (e.g. $1)
#=============================================================================

BasicInfo () {
 for server in `cat  $list | grep -v ^#`                                                 # For each entry in $list that doesn't begin with "#"...
do                                                                                       # Do
serverIP=$(nslookup $server | tail -2 | awk -F ":" '{print $2}')                         ### Translates hostname into IPv4 address
echo "----------------------< $server | $serverIP  >----------------------"              ### Records hostname and IPv4 address
ssh -q $serverIP "cat /etc/redhat-release"                                               ### Pulls RHEL Version
ssh -q $serverIP "uname -r"                                                              ### Pulls Kernel Version
echo $serverIP                                                                           ### Displays IPv4 address again
echo "--------------------------------------------------------------------"
echo
done
}

#========================== SCRIPT  ==========================================

if [ $# -lt 1 ]                                                                          # If parameters used after invocation of script is < 1
    then                                                                                 ### Then
    printf "Usage: %s <USAGE MESSAGE> \n" "$(basename "$0")" >&2                         ### Print script usage message...
    exit 64                                                                              ### ... And exit
    else                                                                                 ### Else
    echo "Starting Script"                                                               ### Start the script and display a confirmation message that the script is starting
fi
BasicInfo                                                                                # Runs "BasicInfo" function
echo "Done!"
exit                                                                                     # Exits script.
