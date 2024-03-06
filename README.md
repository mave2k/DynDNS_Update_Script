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





# Create Cron-Task

Connect to your Synology NAS via SSH.

Edit the /etc/crontab file using a text editor like nano:

Bash
sudo nano /etc/crontab
Use code with caution.
Note: Using sudo is important as the crontab file requires root privileges for modification.

Add a new line to the file with the following format:

minute hour day_of_month month day_of_week command
*/5 * * * * your_command --> every 5 mins

Replace the following placeholders:

minute: The minute (0-59) when the task should run.
hour: The hour (0-23) when the task should run.
day_of_month: The day of the month (1-31) when the task should run. Use * for all days.
month: The month (1-12) when the task should run. Use * for all months.
day_of_week: The day of the week (0-6, where 0 is Sunday) when the task should run. Use * for all days.
command: The command you want to run for the cronjob.
Save the changes and exit the editor.

Restart the cron service:

Bash
sudo systemctl restart crond
Use code with caution.
Remember:

Be cautious when editing the /etc/crontab file, as errors can lead to unexpected behavior.
Ensure the user under which the script runs has the necessary permissions to execute the commands within the cronjob.
Consider using the web UI approach for easier management if you're not comfortable with SSH.
These methods allow you to create cronjobs on your Synology NAS, enabling scheduled execution of various tasks according to your defined schedules.