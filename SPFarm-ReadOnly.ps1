# Load SharePoint PowerShell snap-in if not loaded
if ((Get-PSSnapin -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null) {
    Add-PSSnapin Microsoft.SharePoint.PowerShell
}

# Define the URL of your web application
$webAppUrl = "http://your-webapp-url"
# Define the output CSV file path
$outputFile = "C:\LockedSitesReport.csv"

# Initialize an array to store site information
$siteStatusList = @()

# Get the Web Application object
$webApp = Get-SPWebApplication $webAppUrl

# Iterate through each site collection in the web application
foreach ($site in $webApp.Sites) {
    try {
        # Check if the site is already set to No Access
        $isAlreadyNoAccess = $site.ReadOnly -and $site.WriteLocked
        $lockStatus = if ($isAlreadyNoAccess) { "Already No Access" } else { "Set to No Access" }
        
        # If not already set to No Access, lock the site
        if (!$isAlreadyNoAccess) {
            $site.LockIssue = "Site is temporarily locked for maintenance"
            $site.ReadOnly = $true
            $site.WriteLocked = $true
            $site.Update()
        }

        # Collect site information for the CSV report
        $siteStatusList += [PSCustomObject]@{
            URL             = $site.Url
            LockStatus      = $lockStatus
            TimeLocked      = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        Write-Host "$lockStatus for site collection:" $site.Url -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to process site collection:" $site.Url -ForegroundColor Red
    }
    finally {
        # Dispose of the site object to free up resources
        $site.Dispose()
    }
}

# Export the site status list to a CSV file
$siteStatusList | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "All site collections in the web application have been processed. Report saved to $outputFile" -ForegroundColor Cyan
