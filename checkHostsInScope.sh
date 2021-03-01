#!/bin/bash

# First argument is filename with domains to check
# Second argument is file with in scope IPs
# Problems with this, complain to @hoodoer

declare -a outOfScopeArray;

if [ "$#" -ne 2 ]; then
	echo "Needs 2 params, domain list (file) and an IP list (file)."
	echo "ex: ./checkHostsInScope.sh ./subdomains.txt ./inScopeIPs.txt"
else
	echo "Checking in scope subdomains given in scope IP list..."
	echo 
	echo "In scope:"
	while IFS= read -r line
	do
		for ip in `host $line | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
		do
			if grep -q $ip $2; then
				echo "$line     $ip"
			else
				outOfScopeArray+=("$line     $ip")
				# echo "out-of-scope: $line    $ip"
			fi
		done

	done < "$1"


	echo
	echo "Out of scope:"
	for subdomain in "${outOfScopeArray[@]}"
	do 
		echo "$subdomain"
	done

fi
