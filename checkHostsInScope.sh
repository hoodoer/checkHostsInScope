#!/bin/bash

# if you have problems with, you can try to complain to @hoodoer
# Maybe I'll fix it. Maybe. 

# if you think the optional whois lookup is silly, 
# direct your comments to @Yekki_1


# First argument is filename with domains to check
# Second argument is file with in scope IPs
declare maxWidth=0
declare columnBuffer=5

yekkiMode=false

declare -a outOfScopeArray

if [ "$#" -lt 2 ]; then
	echo "Needs at least 2 params, domain list (file) and an IP list (file)."
	echo "ex: ./checkHostsInScope.sh ./subdomains.txt ./inScopeIPs.txt"
	echo
	echo "Optionally, you can set the flag --yekkiMode at the end to do a whois lookup on org too (slower)"
else
	echo "Checking in scope subdomains given in scope IP list..."
	echo

	# Check if Yekki's whiny whois check is needed. 
	# Because apparently his clients are "special"
	if [[ "$*" == *'--yekkiMode'* ]]; then
		echo "Yekki Mode engaged. Hold onto your brexits."
		yekkiMode=true
	fi
	
	# First we need to see the longest URL to set our column width
	while IFS= read -r line
	do
		len=${#line}

		if ((len > maxWidth));
		then
			maxWidth=$len
		fi;
	done < "$1"

	columnWidth=$((maxWidth+columnBuffer))

	echo 
	echo "In scope:"
	while IFS= read -r line
	do
		for ip in `host $line | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
		do
			if grep -q $ip $2; then

				if $yekkiMode ; then
					# Let's check whois for the organizations for the IP
					declare orgs=""
					while IFS= read -r line2
					do
						orgs+=$line2
						orgs+=", "
					done < <(whois $ip | grep 'Organization:' | sed 's/Organization: //g')
				fi

				printf "%-${columnWidth}s  %-${columnWidth}s" $line $ip

				if $yekkiMode; then
					echo $orgs
				else
					echo
				fi
			else
				if $yekkiMode; then
					declare orgs=""
					while IFS= read -r line2
					do
						orgs+=$line2
						orgs+=", "
					done < <(whois $ip | grep 'Organization:' | sed 's/Organization: //g')
					printf -v fixedOrgs "$orgs\n"
				fi
				
				printf -v stringer "%-${columnWidth}s  %-${columnWidth}s" $line $ip

				if $yekkiMode; then
					outOfScopeArray+="$stringer $fixedOrgs"
				else
					printf -v fixedString "$stringer\n"
					outOfScopeArray+="$fixedString"
				fi
			fi
		done

	done < "$1"


	echo
	echo
	echo "Out of scope"
	for subdomain in "${outOfScopeArray[@]}"
	do 
		echo "$subdomain"
		
	done 

fi
