#! /bin/bash

#==================================================== ===============================
#
# FILE: loop.sh
#
# USAGE: ./loop.sh <LIST.txt> <Foo OR Bar>
#
# DESCRIPTION: Simple script which loops through servers in LIST.txt and executes Foo OR Bar [Functions]
# AUTHOR:  /u/kilrainebc
# COMPANY: [redacted]
# VERSION: 1.0
#===================================================================================

#============================ VARIABLES ==============================================

list=`ls ./$1` #Sets $list variable to parameter 1; should be a list of hostnames.

#============================ FUNCTIONS ==============================================

#=== FUNCTION ================================================================
# NAME: Foo
# DESCRIPTION: Function that will deploy across servers
#               from each server in designated list (e.g. $1)
#=============================================================================

Foo () {
 for server in `cat  $list | grep -v ^#`                                                 # For each entry in $list that doesn't begin with "#"...
do                                                                                       # Do
serverIP=$(nslookup $server | tail -2 | awk -F ":" '{print $2}')                         ### Translates hostname into IPv4 address
echo "----------------------< $server | $serverIP  >----------------------"              ### Records hostname and IPv4 address
ssh -q $serverIP "foo" #foo should be the command you want to run
echo "--------------------------------------------------------------------"
echo
done
}

#=== FUNCTION ================================================================
# NAME: Bar
# DESCRIPTION: Function that will deploy across servers
#               from each server in designated list (e.g. $1)
#=============================================================================

Bar () {
 for server in `cat  $list | grep -v ^#`                                                 # For each entry in $list that doesn't begin with "#"...
do                                                                                       # Do
serverIP=$(nslookup $server | tail -2 | awk -F ":" '{print $2}')                         ### Translates hostname into IPv4 address
echo "----------------------< $server | $serverIP  >----------------------"              ### Records hostname and IPv4 address
ssh -q $serverIP "bar" #bar should be the command you want to run
echo "--------------------------------------------------------------------"
echo
done
}

#========================== SCRIPT  ==========================================

if [[ $# -lt 2 ]]                                                                    # If parameters used after invocation of script is < 2
then                                                                                 ### Then
printf "Usage: %s <LIST.txt> <Foo or Bar> \n" "$(basename "$0")" >&2                 ### Print script usage message...
exit 64                                                                              ### ... And exit
else                                                                                 ### Else
echo "Starting Script"                                                               ### Start the script and display a confirmation message that the script is starting
fi

echo "${2} now starting..."
$2                                                                                   # Runs chosen function
echo "Done!"
exit                                                                                 # Exits script.
