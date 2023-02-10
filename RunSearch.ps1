[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$SearchName,
    [string]$TargetMailbox,
    [switch]$original,
    [switch]$restoreOriginal,
    [switch]$CopyResults
)
$search = Get-ComplianceSearch $SearchName
if ($search.Status -ne "Completed")
{
   "Please wait until the search finishes";
   break;
}
$results = $search.SuccessResults;
if (($search.Items -le 0) -or ([string]::IsNullOrWhiteSpace($results)))
{
   "The compliance search " + $SearchName + " didn't return any useful results";
   "A mailbox search object wasn't created";
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
$msPrefix = $SearchName + "_MBSearch";
$I = 1;
$mbSearches = Get-MailboxSearch;
while ($true)
{
    $found = $false;
    $mbsName = "$msPrefix$I";
    foreach ($mbs in $mbSearches)
    {
        if ($mbs.Name -eq $mbsName)
        {
            $found = $true;
            break;
        }
    }
    if (!$found)
    {
        break;
    }
    $I++;
}
$query = $search.KeywordQuery;
if ([string]::IsNullOrWhiteSpace($query))
{
    $query = $search.ContentMatchQuery;
}
if ([string]::IsNullOrWhiteSpace($query))
{
   New-MailboxSearch "$msPrefix$i" -SourceMailboxes $mailboxes -EstimateOnly;
}
else
{
   if ($CopyResults){
    New-MailboxSearch "$msPrefix$i" -SourceMailboxes $mailboxes -SearchQuery $query -TargetMailbox $TargetMailbox;
    Start-MailboxSearch "$msPrefix$i"
   } else {
    New-MailboxSearch "$msPrefix$i" -SourceMailboxes $mailboxes -SearchQuery $query -EstimateOnly;
    Start-MailboxSearch "$msPrefix$i"

   }
} 
