<#
.SYNOPSIS
This script displays basic data for a given IP Adress using Shodan API

.DESCRIPTION
The script uses Shodan API to fetch various data such as lists of open ports, tags and vulnerabilities associated with a given API Adress.

.PARAMETER IP_Adress
An IPv4 Adress we want to scan for

.EXAMPLE
PS> .\Scan_ip.ps1 -IP_Adress 119.129.13.5

Retrieves basic data mentioned below for the given IP Adress

.NOTES
-In order to successfully use this script you doesn't need to have an api key
-Due to the use of a Shodan InternetDB API the amount of quality and components of fetched data is limited
-Also there are other limitations as to the precision and quality of this data, which can be found at: https://internetdb.shodan.io/
#>

# Parameters
param(
    [Parameter(Mandatory = $true)]
    [string]$IP_Adress
)

#API endpoint for a specific IP Adress
$uri = "https://internetdb.shodan.io/$IP_Adress"

#Invoke the REST API for the current keyword
$response = Invoke-RestMethod -Uri $uri -Method Get

#Fetching data from a response json object
Write-Host "`nDisplaying found data for a $IP_Adress IP Adress:"

Write-Host "`n-----------------------------OPEN PORTS------------------------------"
#Displaying all open ports
foreach ($port in $response.ports) {
    Write-Host "`n$port port is currently open"
}

Write-Host "`n-------------------------VULNERABILITIES----------------------------"
#Displaying all potential vulnerabilities
foreach ($vuln in $response.vulns) {
    Write-Host "`n$vuln potential vulnerability was found"
}

Write-Host "`n-------------------------------TAGS--------------------------------"
#Displaying all tags
foreach ($tag in $response.tags) {
    Write-Host "`n$tag is a tag for $IP_Adress"
}

Write-Host "`n-----------------------------HOSTNAMES------------------------------"
#Displaying all hostnames
foreach ($hostname in $response.hostnames) {
    Write-Host "`n$hostname is a hostname for $IP_Adress"
}