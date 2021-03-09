# checkHostsInScope
Bash script to take a list of domains/subdomains (e.g. from amass) and check if they're in scope based on a file of inscope IP addresses

e.g. ./checkHostsInScope.sh ./subdomains.txt ./inScopeIPs.txt


Optionally you can also do a whose on the IP address and get the owning organization like so:

e.g. ./checkHostsInScope.sh ./subdomains.txt ./inScopeIPs.txt --yekkiMode
