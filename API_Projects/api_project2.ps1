<#
  .SYNOPSIS
  This script searches for the latest articles on a given topic using newsdata.io API

  .DESCRIPTION

  This script searches for the latest articles on a given topic using newsdata.io API, also it requires to specify a language
  in which fetched data must be written 

  .PARAMETER Language

  ISO 639 Language code representing each language using 2 or 3 letter lowercase abbreviation. Required 
  to specify the language in which you want to obtain the data, news, articles etc. 
  For example: English -> en , Polish -> pl , Spanish -> es

  .EXAMPLE
  PS> .\quantum_computing_articles.ps1 -Language en

  Retrieves all latest articles written in english consisting of 'quantum computing' keyword
    
  .NOTES

  -In order to succesfully use this script you need to have an api key from newsdata.io website
  -The free api key used in this script might have some limitations as to the number of allowed requests and options to fetch data, more info
  available in this link: https://newsdata.io/free-news-api

#>


param(

    [Parameter(Mandatory = $true)]
    [string]$Language
)


#Prompting for a keyword to search for and then encoding it using System.Web.HttpUtility
$keyword = Read-Host "Please enter a topic you are intrested in"
Add-Type -AssemblyName System.Web
$encodedKeyword = [System.Web.HttpUtility]::UrlEncode($keyword)


# Prompting for API key
$api_key = Read-Host "Enter your API key (input will be hidden)" -AsSecureString
$api_key_plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($api_key))


#API endpoint for a specific keyword
$uri = "https://newsdata.io/api/1/latest?apikey=$api_key_plain&q=$encodedKeyword&language=$Language"


# Securely dispose of the SecureString object
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($api_key))

#Inovek the REST API for the current keyword
$response = Invoke-RestMethod -Uri $uri -Method Get


#Fetching links to the top ten articles on a given topic
try {
    
    if ($response.Status) {
        for ($i = 0; $i -lt [Math]::Min(10, $response.results.Count); $i++) {
            $article = $response.results[$i]
            Write-Host "`nArticle Title: $($article.title)"
            Write-Host "Article Description: $($article.description)"
            Write-Host "Link to the article: $($article.link)"
        }
    }
    else {
        Write-Error "API call failed for keyword: $keyword. Error $($response.results["message"])"
    }

}
catch {

    #Handle any network or or other exceptions
    Write-Error "An error occured: $($_.Exception.Message)"
}