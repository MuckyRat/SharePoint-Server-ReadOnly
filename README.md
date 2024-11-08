# SharePoint 2019 Site Lock Script

This PowerShell script sets all site collections within a specified SharePoint 2019 on-premises web application to "No Access," restricting user access to the sites. This is useful for maintenance or administrative purposes. The script also exports a CSV report with details on each site collection's URL, lock time, and whether it was previously set to "No Access."

## Prerequisites

+ Environment: Run this script in the SharePoint Management Shell.
+ Permissions: Ensure you have administrative rights to manage site collections.
+ Variables to Configure:
  + $webAppUrl: Update this with the URL of the target SharePoint web application.
  + $outputFile: Specify the path for the CSV output file.

## How It Works

+ Load SharePoint Snap-In: Ensures the SharePoint PowerShell snap-in is loaded.
+ Define Variables:
  + $webAppUrl: The URL of the SharePoint web application you want to lock down.
  + $outputFile: The path to save the CSV report (e.g., C:\LockedSitesReport.csv).
+ Initialize Report Array: Creates $siteStatusList to store site collection information.
+ Loop Through Site Collections
  +  For each site in the web application
      + Checks if it’s already locked (both ReadOnly and WriteLocked properties are true).
      + If not, it locks the site by setting ReadOnly and WriteLocked properties to true.
      + Collects each site’s URL, lock status, and timestamp and stores them in $siteStatusList.
+ Export to CSV: Exports $siteStatusList to a CSV file at the specified path.

## CSV Report
The CSV file contains:

+ URL: The URL of each site collection.
+ LockStatus: Indicates if the site was "Already No Access" or was newly "Set to No Access."
+ TimeLocked: Timestamp for when the lock was applied.
