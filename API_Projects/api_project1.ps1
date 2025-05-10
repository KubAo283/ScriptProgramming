<#
.SYNOPSIS
    Obtains the chosen currency exchange rate against a base currency for the previous 5 days
    using the currencybeacon.com API and then calculates the difference in exchange rates between each day.

.DESCRIPTION
    This script uses the currencybeacon.com API to retrieve the exchange rate
    for a chosen currency against a specified base currency for the last 5 days
    (including today). You will need to sign up for a free API key at
    currencybeacon.com to use this script.

.PARAMETER BaseCurrency
    The three-letter ISO currency code of the base currency you want to compare against the chosen currency.
    For example: USD, EUR, GBP.

.PARAMETER Currency
    The three-letter ISO currency code of the target currency for which you want to obtain the exchange rate.
    For example: JPY, GBP, EUR.

.EXAMPLE
    .\Get-CurrencyRateHistory.ps1 -BaseCurrency USD -Currency JPY

    Outputs the exchange rate of JPY against USD for the previous 5 days and the daily differences.

.NOTES
    - You need an API key from currencybeacon.com. Replace 'YOUR_API_KEY' with your actual key OR use a more secure method.
    - The free tier of currencybeacon.com might have limitations on the base currency and
      historical data access.
    - Ensure you have internet connectivity to run this script.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$BaseCurrency,
    [Parameter(Mandatory = $true)]
    [string]$Currency
)

# Prompting for API key
$api_key = Read-Host "Enter your API key (input will be hidden)" -AsSecureString
$api_key_plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($api_key))


Write-Host "`n"

# Dates array
$dates = New-Object System.Collections.ArrayList
for ($i = 0; $i -lt 5; $i++) {
    $dates.Add((Get-Date).AddDays(-$i).ToString("yyyy-MM-dd"))
}

$date_rate = @{}
try {

    Write-Host "`nExchange rate of $($Currency) against $($BaseCurrency) for the previous 5 days:"
    foreach ($date in $dates) {

        # API endpoint URL for a specific date
        $uri = "https://api.currencybeacon.com/v1/historical?api_key=$api_key_plain&date=$date&base=$BaseCurrency&symbols=PLN,GBP,EUR"

        # Securely dispose of the SecureString object
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($api_key))


        # Invoke the REST API for the current date
        $response = Invoke-RestMethod -Uri $uri -Method Get

        # Check if the API call was successful for this specific date
        if ($response.rates) {
            $rate = $response.rates.$Currency
            Write-Host "`n$date : $($rate)"
            $date_rate["$date"] = $rate
        }
        else {
            Write-Error "API call failed for date: $date. Error: $($response | ConvertTo-Json -Depth 3)"
        }
    }
}
catch {
    # Handle any network or other exceptions
    Write-Error "An error occurred: $($_.Exception.Message)"
}

# Calculating difference in rates between each day
Write-Host "`nDifference in exchange rates between consecutive days:"
$sortedDates = $date_rate.Keys | Sort-Object
for ($i = 0; $i -lt $sortedDates.Count - 1; $i++) {
    $currentDate = $sortedDates[$i]
    $nextDate = $sortedDates[$i + 1]
    $difference = $date_rate[$nextDate] - $date_rate[$currentDate]
    Write-Host "`nBetween $($currentDate) and $($nextDate): $($difference)"
}