#!/bin/bash

domains=("kopen.at")
TOKEN=qmgzvBsRJi2QBRE1RmPspYcwt48X

# What this does
# - Query DNS Servers of Google for the TXT record
# - o-o.myaddr.l.google.com: This is a special subdomain provided by Google that returns your public IP address when queried with a TXT record lookup
# - @ns1.google.com: This specifies the DNS server to be used for the query. In this case, we are using Google's nameserver ns1.google.com
# - Also remove starting and trailing ""
ipv4=$(echo "$(dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com)" | sed 's/^"//; s/"$//')
ipv6=$(echo "$(dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com)" | sed 's/^"//; s/"$//')

# echo $ipv4 $ipv6

# Exiting if ip address is empty
if [ -z "$ipv4" ] || [ -z "$ipv6" ]; then
    echo "IP address is empty. Exiting!"
    exit 1
fi

# Exiting if IP addresses are unchanged
if [ "$(head -n 1 address.txt)" == "$ipv4" ] && [ "$(head -n 2 address.txt | tail -n 1)" == "$ipv6" ]; then
    echo "IP addresses are unchanged. Ending."
    exit 0
fi

# Update address.txt with new values
echo "$ipv4" >address.txt
echo "$ipv6" >>address.txt

# The Desec Update Command
# curl --user kopen.at:$TOKEN "https://update.dedyn.io/?myipv4=${ipv4}&myipv6=${ipv6}"

# Loop through each domain in the array
for domain in "${domains[@]}"; do
    # Construct the full URL with the current domain
    url="https://update.dedyn.io/?myipv4=${ipv4}&myipv6=${ipv6}"
    url="${url//DOMAIN.COM/$domain}" # Replace placeholder with current domain
    echo "Executing update for $domain:"
    echo "Response: "
    # Execute the curl command with the constructed URL and provided credentials
    curl --user "$domain:$TOKEN" "$url"
done

echo $ipv4 $ipv6
