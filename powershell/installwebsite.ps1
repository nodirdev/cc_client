Import-Module WebAdministration
$iisAppPoolName = "cc_client"
$iisAppPoolDotNetVersion = "v4.0"
$iisAppName = "cc_client"
$directoryPath = "c:\temp\cc_client"

Stop-WebSite 'Default Web Site'

#set the autostart property so we don't have the default site kick back on after a reboot
# cd IIS:\Sites\
# Set-ItemProperty 'Default Web Site' serverAutoStart False

cd IIS:\AppPools\

if (!(Test-Path $iisAppPoolName -pathType container))
{
    #create the app pool
    $appPool = New-Item $iisAppPoolName
    $appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value $iisAppPoolDotNetVersion
}

#navigate to the sites root
cd IIS:\Sites\

#check if the site exists
if (Test-Path $iisAppName -pathType container)
{
    return
}

#create the site
$iisApp = New-Item $iisAppName -bindings @{protocol="http";bindingInformation=":80:"} -physicalPath $directoryPath
$iisApp | Set-ItemProperty -Name "applicationPool" -Value $iisAppPoolName