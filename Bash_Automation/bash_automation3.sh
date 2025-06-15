#!/bin/bash

: '
This script fetches the weather data for a given city using weather api ( weatherapi.com )
and then based on the received outcome, it generates pdf report including info such as:

-City name
-Current temperature and humidity
-Forecast for the next five days

Also, it requires jq and pandoc to be installed on the system
'

#Prompting for city's name
read -p "Choose the city: " city

#Getting API key
read -s -p "Enter your API key: " api_key
printf "\n"

#Obtaining 5 days forecast for a choosen city

response=$(curl --silent --request GET \
  --url "https://api.weatherapi.com/v1/forecast.json?key=$api_key&q=$city&days=5")

#Checking if the API call was successful
if [[ -z "$response" || "$response" == "null" ]]; then
    echo "Failed to retrieve weather data. Check API response:"
    echo "$response"
    exit 1
fi

#Extracting 5-day forecast data (date, condition, min and max temperature)
forecast=$(echo "$response" | jq -r '.forecast.forecastday[] | "\(.date): \(.day.condition.text), min: \(.day.mintemp_c)°C, max: \(.day.maxtemp_c)°C"')

#Obtaining current temperature and humidity
temperature=$(echo "$response" | jq -r '.current.temp_c')
humidity=$(echo "$response" | jq -r '.current.humidity')

#Preparinng the report in Markdown format and then converting it to PDF

#File names for the report
report_file="weather_report.md"
pdf_file="weather_report.pdf"

{
  echo "# Weather Report for $city"
  echo "## Current Conditions"
  echo "- Temperature: $temperature °C"
  echo "- Humidity: $humidity %"
  echo ""
  echo "## 5-Day Forecast"
  echo "$forecast"
} > "$report_file"



#Converting Markdown report to PDF using pandoc
pandoc "$report_file" -o "$pdf_file"

echo "Weather report for $city has been generated and saved as $pdf_file"
# Cleaning up the temporary Markdown file
rm "$report_file" 