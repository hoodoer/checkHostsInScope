#!/bin/bash

# if you have problems with, you can try to complain to @hoodoer
# Maybe I'll fix it. Maybe. 


# First argument is filename with domains to check
# Second argument is file with in scope IPs
# Problems with this, complain to @hoodoer
declare maxWidth=0;
declare columnBuffer=5

declare -a outOfScopeArray;

if [ "$#" -ne 2 ]; then
	echo "Needs 2 params, domain list (file) and an IP list (file)."
	echo "ex: ./checkHostsInScope.sh ./subdomains.txt ./inScopeIPs.txt"
else
	echo "Checking in scope subdomains given in scope IP list..."
	
	# First we need to see the longest URL to set our column width
	while IFS= read -r line
	do
		len=${#line}

		if ((len > maxWidth));
		then
			maxWidth=$len
		fi;
	done < "$1"

	columnWidth=$((maxWidth+columnBuffer));

	echo 
	echo "In scope:"
	while IFS= read -r line
	do
		for ip in `host $line | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
		do
			if grep -q $ip $2; then
				printf "%-${columnWidth}s  %-${columnWidth}s" $line $ip
				echo
			else
				printf -v stringer "%-${columnWidth}s  %-${columnWidth}s\n" $line $ip
				outOfScopeArray+=$stringer
			fi
		done

	done < "$1"


	echo
	echo "Out of scope:"
	for subdomain in "${outOfScopeArray[@]}"
	do 
		echo "$subdomain"
		echo
	done 

fi
