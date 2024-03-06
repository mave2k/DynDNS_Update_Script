# Synology/Mac Custom Domain updater for Dynamic IP addresses

This is a handy little bash script to dynamically update DNS entries for your custom domains you want to point to your Synology NAS when you do not have a static IP.

## This is for you, if...

- You own 1..n domains and
- Want to host the contents behind them on top level on you Synology NAS
- Your Synology NAS sits behind a router that has a dynamic IP which your ISP changes (usually once / 24h)

*Example*: You own the domain example.com and want to host your wordpress site on you Synology NAS, making it available at https://example.com

*Remark*: If you only want to use subdomains (e.g. photos.example.com) you can do this easier with CNAME records that point to a DynDNS domain. A-records for the domain itself are not allowed to be CNAMES. Thus, the dynamic update of the A-records is required.


# Prerequisites

## DNS Service that allows for dynamic updating

## Changing the DNS server for your domain
