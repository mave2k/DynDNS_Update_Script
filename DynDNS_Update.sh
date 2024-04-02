#!/bin/bash
source config.sh

echo $TOKEN 
echo $DOMAINS
echo $OLD_IPv4
echo $OLD_IPv6

# What this does
# - Check if this is Mac or Synology DSM and tweak the commands accordingly
# - Query DNS Servers of Google for the TXT record
# - o-o.myaddr.l.google.com: This is a special subdomain provided by Google that returns your public IP address when queried with a TXT record lookup
# - @ns1.google.com: This specifies the DNS server to be used for the query. In this case, we are using Google's nameserver ns1.google.com
# - Also remove starting and trailing ""
if [[ $(uname) == "Darwin" ]]; then
    # Code specific to macOS --> dig is available
    ipv4=$(echo "$(dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com)" | sed 's/^"//; s/"$//')
    ipv6=$(echo "$(dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com)" | sed 's/^"//; s/"$//')
    echo "This code runs on macOS."
elif [[ $(uname) == "Linux" ]]; then
    # Code specific to Syno-DSM --> dig binary taken from the DNS Server package
    ipv4=$(echo "$(/var/packages/DNSServer/target/bin/dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com)" | sed 's/^"//; s/"$//')
    # Remember: Enable IPv6 on Synology in the Network --> Network Interface --> Manage section first
    ipv6=$(echo "$(/var/packages/DNSServer/target/bin/dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com)" | sed 's/^"//; s/"$//')
    echo "This code runs on SynoDSM"
else
    # Code for other operating systems (optional)
    echo "This code runs on an unknown operating system."
    exit 1
fi


echo "Current external IP addresses are:"
echo "IPv4: " $ipv4
echo "IPv6: " $ipv6
echo "----------------------------------"

# Exiting if ip address is empty
if [ -z "$ipv4" ] || [ -z "$ipv6" ]; then
    echo "IP address is empty. Exiting!"
    exit 1
fi

# # Exiting if IP addresses are unchanged
echo "Old IP4= " $OLD_IPv4
echo "Old IP6= " $OLD_IPv6

if [ $OLD_IPv4 == $ipv4 ] && [ $OLD_IPv6 == $ipv6 ]; then
    echo "IP addresses are unchanged. Ending."
    exit 0
fi


# The Desec Update Command
# curl --user kopen.at:$TOKEN "https://update.dedyn.io/?myipv4=${ipv4}&myipv6=${ipv6}"

# Loop through each domain in the array
for domain in "${DOMAINS[@]}"; do
    # Construct the full URL with the current domain
    url="https://update.dedyn.io/?myipv4=${ipv4}&myipv6=${ipv6}"
    url="${url//DOMAIN.COM/$domain}" # Replace placeholder with current domain
    echo ""
    echo "Executing update for $domain:"
    echo "----------------------------------"
    # Execute the curl command with the constructed URL and provided credentials
    res=$(curl --user "$domain:$TOKEN" "$url")
    echo "----------------------------------"
    echo "Response: " $res
    echo ""
done

# Update config.txt with new values
echo "TOKEN=\""$TOKEN"\"" > ./config.sh
echo "DOMAINS=("${DOMAINS[@]}")" >> ./config.sh
echo "OLD_IPv4=\""$ipv4"\"" >> ./config.sh
echo "OLD_IPv6=\""$ipv6"\"" >> ./config.sh
