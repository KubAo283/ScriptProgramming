#This is simple script that displays basic system info

########################################################
#Descripton: DateDisplay function
#Globals:
#device => Single pass argument
#Arguments:
#None
#Outputs:
#Current date on a $device
#Returns:
#None
#######################################################
Function DateDisplay {
	
    param ( $device )
    $date = Get-Date
    Write-Host  "The date on a $device is : $date"

}



########################################################
#Descripton: SysVersionDisplay function
#Globals:
#device => Single pass argument
#Arguments:
#None
#Outputs:
#Current operating system version on a $device
#Returns:
#None
#######################################################
Function SysVersionDisplay {

    param( $device )
    $version = (Get-ComputerInfo | Select-Object WindowsProductName).WindowsProductName
    Write-Host  "The version of Windows on a $device is : $version"

}


########################################################
#Descripton: UserInfo function
#Globals:
#device => Single pass argument
#Arguments:
#None
#Outputs:
#Currently logged in user on a $device
#Returns:
#None
#######################################################
Function UserInfo {

    param( $device )
    $user = $env:USERNAME
    Write-Host  "The user on a $device is : $user"

}


########################################################
#Descripton: IpAddress function
#Globals:
#device => Single pass argument
#Arguments:
#None
#Outputs:
#Current IP Address on a $device
#Returns:
#None
#######################################################
Function IpAddress {

    param ( $device )
    $ip_address = (ipconfig | Select-String "IPv4").ToString().Split(":")[1].Trim()
    Write-Host  "The device IP Address is : $ip_address"

}


########################################################
#Descripton: Main function
#Globals:
#Arguments:
#$device => Single pass argument
#None
#Outputs:
#DateDisplay, SysVersionDisplay, UserInfo, IpAddress functions
#Returns:
#None
#######################################################
Function Main {

    $device = Read-Host "Enter your device name "

    DateDisplay $device

    SysVersionDisplay $device

    UserInfo $device

    IpAddress $device

}

#Calling Main function
Main