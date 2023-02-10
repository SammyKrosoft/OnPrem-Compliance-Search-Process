# Compliance Search Process

## Permissions

- To be able to run the ```New-ComplianceSearch``` cmdlet, you need the "Mailbox Search" management role, which is part of the "Discovery Management" role group (or you can create a custom role group with the Mailbox Search management role inside)

- To be able to run the ```New-MailboxSearch``` cmdlet, you need the "Legal Hold" management role, which is part of the "Discovery Management" role group as well (or again, you can create a custom role group with the Legal Hold management role inside)

- In addition to the above 2 management roles (both present in the "Discovery Management" Role Group), you might also need to have the "Mailbox Import Export" management role to be able to export results with New-MailboxSearch cmdlet (last step on the below procedure). Here's a way to give a user or yourself the permissions to export search results, in the below example for the user samdrey of the CanadaDrey domain:

```powershell
# Create a new Role Group with a meaningful name of your choice
New-RoleGroup "Import and Export permissions"
# Add the "Mailbox Import Export" built-in role to this new Role Group
New-ManagementRoleAssignment "Import Export Assignment" -SecurityGroup "Import and Export permissions" -Role "Mailbox Import Export"
# Add a user or yourself as a member of this ROle Group
Add-RoleGroupMember -Identity "Import and Export Permissions" -Member canadadrey\samdrey
```

Or another example, if you need to give users the Mailbox Search, the Legal Hold and the Mailbox Import Export management roles, you can create a custom Role Group with these commands:

```powershell
# Create a new Role Group with a meaningful name of your choice
$MeaningfulName = "Permissions for Compliance Search and Results Export"
New-RoleGroup $MeaningfulName
# Add the "Mailbox Import Export" built-in role to this new Role Group
New-ManagementRoleAssignment "Mailbox Search Assignment" -SecurityGroup $MeaningfulName -Role "Mailbox Search"
New-ManagementRoleAssignment "Legal Hold Assignment" -SecurityGroup $MeaningfulName -Role "Legal Hold"
New-ManagementRoleAssignment "Mailbox Import Export Assignment" -SecurityGroup $MeaningfulName -Role "Mailbox Import Export"

# Add a user or yourself as a member of this ROle Group
Add-RoleGroupMember -Identity $MeaningfulName -Member canadadrey\samdrey
```

## Compliance Search Process

Here's the process to complete Compliance Search and results exports as detailed in [this Microsoft article](https://learn.microsoft.com/en-us/exchange/policy-and-compliance/ediscovery/compliance-search?view=exchserver-2019):

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

# Step 2 (Optionnal) - Counting the number of mailboxes with results in these - check you have less than 500 with results, otherwise
# you might need to narrow down the search with a better KQL query, or create groups of mailboxes with Distribution Lists, and use
# -ExchangeLocation <Distribution List Name or SMTP address> with New-ComplianceSearch cmdlet.

.\Count-SourceMailboxes.ps1 $SearchName

# Step 3 - Run the script to search and estimate or copy the results in a Discovery Mailbox (to later export these to a PST file)

# To estimate only the search results

.\RunSearch.ps1 -SearchName $SearchName

# To copy the results into a target mailbox

.\RunSearch.ps1 -SearchName $SearchName -TargetMailbox Discovery.Mailbox01@contoso.ca -CopyResults
```

