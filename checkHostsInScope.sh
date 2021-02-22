#!/bin/bash

# First argument is filename with domains to check
# Second argument is file with in scope IPs


if [ "$#" -ne 2 ]; then
	echo "Needs 2 params, domain list (file) and an IP list (file)."
	echo "ex: ./checkHostsInScope.sh ./subdomains.txt ./inScopeIPs.txt"
else
	echo "Checking in scope subdomains given in scope IP list..."
	while IFS= read -r line
	do
		for ip in `host $line | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
		do
			if grep -q $ip $2; then
				echo "$line     $ip"
			fi
		done

	done < "$1"
fi
