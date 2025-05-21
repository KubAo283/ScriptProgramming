#!/bin/bash

#How does it work?
: <<'END_COMMENT' 
This script monitors journald logs for any failed or suspicious activites while trying or connecting to ssh server such us: 
failed login attempts, failed passwords, invalid users, top offending IPs, root login attempts and other suspicious activities 
( ex. unexpected disconnections, reverse DNS lookup failures, bad identifications ) and it then writes any discovered flaws to 
report file. The script is also scheduled using cron, to be executed every day at 11.
END_COMMENT

# Output report file
REPORT_FILE="/var/log/ssh_journal_report_$(date +%F_%T).log"

echo "SSH Security Report - $(date)" > "$REPORT_FILE"
echo "Analyzing SSH logs from journalctl" >> "$REPORT_FILE"
echo "--------------------------------------------------" >> "$REPORT_FILE"

# Checking for failed login attempts
echo -e "\n[Failed Login Attempts]" >> "$REPORT_FILE"
journalctl -u ssh --no-pager | grep "Failed password" >> "$REPORT_FILE"

# Checking for invalid user attempts
echo -e "\n[Invalid User Attempts]" >> "$REPORT_FILE"
journalctl -u ssh --no-pager | grep "Invalid user" >> "$REPORT_FILE"

# Checking for top 10 IPs with failed login 
echo -e "\n[Top Offending IPs - Failed Passwords]" >> "$REPORT_FILE"
journalctl -u ssh --no-pager | grep "Failed password" | \
    grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
    sort | uniq -c | sort -nr | head -10 >> "$REPORT_FILE"

# Checking for root login attempts
echo -e "\n[Root Login Attempts]" >> "$REPORT_FILE"
journalctl -u ssh --no-pager | grep "sshd" | grep "root" >> "$REPORT_FILE"

# Checking for suspicious connection patterns (e.g. disconnects, bad banners)
echo -e "\n[Other Suspicious Activities]" >> "$REPORT_FILE"
journalctl -u ssh --no-pager | grep -Ei "Did not receive identification|disconnect|reverse mapping" >> "$REPORT_FILE"

#Ouputs the location of saved report
echo -e "\nReport saved to: $REPORT_FILE"

