# NOTE: This script is a bit modified from the original located on one of the below links:
# https://learn.microsoft.com/en-us/exchange/policy-and-compliance/ediscovery/compliance-search?view=exchserver-2016
# https://learn.microsoft.com/en-us/exchange/policy-and-compliance/ediscovery/compliance-search?view=exchserver-2019
# NOTE 2 : the above links are for both E2019 and E2016, which are basically the same articles ...

[CmdletBinding()]
Param(
     [Parameter(Mandatory=$True,Position=1)]
     [string]$SearchName
)
$search = Get-ComplianceSearch $SearchName
if ($search.Status -ne "Completed")
{
                "Please wait until the search finishes.";
                break;
}
$results = $search.SuccessResults;
if (($search.Items -le 0) -or ([string]::IsNullOrWhiteSpace($results)))
{
                "The compliance search " + $SearchName + " didn't return any useful results.";
                break;
}
$mailboxes = @();
$lines = $results -split '[\r\n]+';
foreach ($line in $lines)
{
    if ($line -match 'Location: (\S+),.+Item count: (\d+)' -and $matches[2] -gt 0)
    {
        $mailboxes += $matches[1];
    }
}
"Number of mailboxes that have search hits: " + $mailboxes.Count
