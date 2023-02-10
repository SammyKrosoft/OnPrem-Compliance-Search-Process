# Sample-ComplianceSearch-OnPrem

Here is a sample Compliance and eDiscovery search example

```powershell
$SearchName = "e-Mail With Attachment MyFile.pdf"
$Query = 'sent>=01/01/2023 AND sent<=06/30/2023 AND attachmentnames:MyFile.pdf'
New-ComplianceSearch -Name $SearchName -ExchangeLocation all -ContentMatchQuery $Query

Start-ComplianceSearch -Identity $SearchName

.\SourceMailboxes.ps1 $SearchName
```

