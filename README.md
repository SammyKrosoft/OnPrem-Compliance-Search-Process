# Sample-ComplianceSearch-OnPrem

Here is a sample Compliance and eDiscovery search example

```powershell
# Placing the search parameters in variables for convenience (avoiding to writing the same strings several times)
# The name of the search (and the eDiscovery New-MailboxSearch later on)
$SearchName = "e-Mail With Attachment MyFile.pdf"
# The query string in Keyword Query Language
# For mail specific parameters, you can use the operators (AND, OR, ...) as well as the following properties:
# AttachmentNames, Bcc, Category, Cc, Folderid, From, HasAttachment, Importance, IsRead, ItemClass, Kind, Participants, Received, Recipients, Sent, Size, Subject, To
$Query = 'sent>=01/01/2023 AND sent<=06/30/2023 AND attachmentnames:MyFile.pdf'

# Step 1 - Creating the Compliance Search
New-ComplianceSearch -Name $SearchName -ExchangeLocation all -ContentMatchQuery $Query

# Step 1 bis - Starting the compliance search
Start-ComplianceSearch -Identity $SearchName

# Step 2 - Counting the number of mailboxes with results in these - check you have less than 500 with results, otherwise
# you might need to narrow down the search with a better KQL query, or create groups of mailboxes with Distribution Lists, and use
# -ExchangeLocation <Distribution List Name or SMTP address> with New-ComplianceSearch cmdlet.
.\SourceMailboxes.ps1 $SearchName
```

