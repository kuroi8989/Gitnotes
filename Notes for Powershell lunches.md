Get-Process | Stop-Process #will crash your computer since it grabs all process than stops all of them.


Chapter 4 Lab
5)Export-CSV -delimiter "|"
6)-NoTypeInformation
7)-Append and -COnfirm
8)-UseCulture


Chapter 5
PSSnapin consists of one or more DLL files. We can see what snaps our shell has with Get-PSSnapin -registered.
This will proivde a list of snaps that are on our shell but not loaded in. We than use Add-PSSnapin *name of snap* and it is now loaded. Find out what commands were loaded? We use:
gcm -pssnapin *nameofsnap*

Moduels are designed to be self contained and easier to distribute. Modules are automatically searched for when enabled. The PSModulePath environment variable will define the path that our shell will look in.
Get-Content env:psmodulepathC:\Users\dispatch15_adm\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Module
s\;C:\Program Files (x86)\Adaptiva\AdaptivaClient\data\PSModules

To find out what modules are available we can either 
A) dir C:\windows\system32\windowspowershell\v1.0\Modules
B) Get-Module -listavailable

If a module is in a predefined path (and thusly discoverable by the two above methods) we will use:
Import-Module *module-name*
gcm -module *nameofmodule* will show what commands have been added by your new module.

ScriptProperty
Property
Noteproperty
AliasProperty
All the above are essentially the same objects but the values in which those properties are obtained are differnet for each.

OBjects can also have events. Events are an object's way of notifying you that something has happened. A process object can trigger its Exited event when the process ends.

STart-MPScan -ScanType QuickSCan/FullScan -Scanpath C:
TEst-Path when combined with IF can really ensure scripts work

Get-Credential 
$creds = Get-Credential will fetch the device's credentials and stores it in the $creds object. Than you can use it for any sort of scripts.
Invoke-Command  uses towards remote-machines.

INvoke-Command -ComputerNam *nameofdevice* -Credential $creds -SCriptBlock { Get-ExecutionPolicy} allows for execution on remote machines. Best for single commands as multiple inputs will require many credential submissions

Enter-PSSession. Enters a SESSION on remote machine so it'll be like you're in it's command.

Enter-PSSession -ComputerName svr01 -Credential $creds

Select-File can select specific properties. Compare these two:
Get-Process | ConvertTo-HTML | Out-File test11.html
Get-Process | Select-Object -Property Name,ID,VM,PM | COnvertTo-HTML | Out-File test22.html
Note at 4 proeprty list it's still a table but at 5 it becomes a list.

ONe returns back 20 + columns, the other is much more concise.

GM is Get-Member. It analyzes the properties and
6.10 LAB
1) Get-Random 
2)get-date
3) System.DateTime
4) GEt-Date | Select-Object DayOfWeek
5) Get-Hotfix | Select InstalledOn,InstalledBy,HotFixID | Sort-Object -Descending InstalledOn (YUSSS)

Get-EventLog -Newest 50 -LogName Security | Sort-Object -Property TimeGenerated,EventID | Select Index,TimeGenerated,Source | Out-File C:\workCode\TestOutput\output.txt

STop-Service has 3 parameter sets. 
    1) includes a mandatory -Name parameter. YOu just specify the name and it kills it
    2) features a mandatory -displayname parameter giving another way to name the process to kill
    3)includes  a mandatory -INputObject parameter accepts values of a ServiceCOntroller type. THis is to pipe in objects from Get-Service
Stop-SErvice with -InputObject knows it takes in ServiceController objects ByValue. When Get-Service | Stop-Service -InputOBject it means the values are compatible. 
"BITS", "MSISCSI" | Start-Service  *** Why does this work?
BITS and MSISCSI are names of services being piped into the cmdlet STart-SErvice. As long as STart-SErvice does accept "NameIDs" and recognize BITS and MSISCSI as the names of said services than it knows and starts them up. Since they have "" they are interpreted as STRINGS. Running Help Start-SErvice -full you see that -INputObject and -Name parameters accept pipeline input ByValue. Strings will thusly attach to one of those two parameters. Since -InputObject needs a proper object that is ruled out but -Name takes input via strings.
OUr goal is to get a list of computer names piped into Get-Service. The below won't do that
GEt-COntent C:\names.txt | Get-SErvice
Get-Content will pipe strings into Get-SErvice. Get-SErvice's -ComputerName isn't the default string accept it's -Name. With THE POWER OF PARANTHESIS (bow before me puny mathematicians) you can get it to pipe in ComputerName and get the results you needed.
Get-Service -computerName (Get-Content c:\names.txt) In this context the paranthesis is telling the -computerName parameter to accept what's in parantheses as its input.

INput Objects:
ByValue: object contains a value whether string or integer
Bypropertyname: These two are mutually exclusive.. Looks at individual properties of objects in the pipeline and sees if any of those properties' names happen to match names of parameters on the next cmdlet. In Get-Process -name b*  | Stop-Service. Instead of erroring out because Name can be passed as string. Since a property name and parameter names can be different this doesn't always work and is inconsistent.


****** IMPORTANT MAKE SURE YOU DRILL THIS ONCE LAB IS UP******
Using a Windows NOtePad or MIcrosoft OFfice Excel create a CSV file something like this
samAccountName,Name,Department,City,Title,GivenName,SurName
DonJ,DonJ,IT,Las Vegas,CIO,Don,Jones
GregS,GregS,Janitorial,Denver,Custodian,Greg,Shields
JeffH,JeffH,IT,Syracuse,Technician,Jeffery,Hicks
ChrisG,ChrisG,Finance,Las Vegas,Accountant,Christopher,Gannon
Save that above in an excel file or a notepad file with quotations "" around it. using Import-CSV will import all those users into powershell allowing for enmasse AD Users added. Import-CSV construcst an object for each row in the file. Each column in the file becomes a property of those objects.
IMport-CSV C:\names.csv | New-ADUser
All those names piped into ADuser means you just got a load of new users on your directory. To get the users added ot somewhere specific: Import-CSV c:\names.csv | New-ADUSer  -path "OU=Sales,dc=Company,dc=pri"
Now AD always requires samAccountName and Name properties.
Below is how we can format improperly formatted CSV files for new-ADuser
Import-CSV c:\users\dispatch15_adm\Downloads\users2.csv |
➥ Select-Object *,@{l='samAccountName';e={$_.LoginName}},
➥ @{l='Name';e={$_.LoginName}},    
➥ @{l='GivenName';e={$_.FirstName}},
➥ @{l='Surname';e={$_.LastName}} These {} signify what value powershell is taking in this case LastName property in the csv.
Import-CSV C:\Users\dispatch15_adm\Downloads\users2.csv | Select-Object *#thisselects all properties the objects have###,@{l='samAccountName';e={$_.LoginName}}, @{l='Name';e={$_.LoginName}}, @{l='GivenName';e={$_.FirstName}}, @{l='Surname';e={$_.LastName}} 
WORKS! Lower case l='samAccountName' is the label or the column. the e after the ; is the value. $_.Login/First/LastName is the assigned value in the file. 
@{l='Surname';e={$_.LastName}} = HASHTABLE. Select-OBject is designed to work with constructs like this. They're dictionaries. Key:Value pairs. These dictionaries consists of two elements and each element has a Key and Value
Label Key - Value is name of new property to be added. 
Expression Key - Value {what's in here}
$_ is a place holder will fill in with the objects from Select-OBject the period in $_. means that it is only accessing a single property(column). $_.LoginName only pulls the value from the LoginName column. l='samAccountName" creates it (l= is substantiating the object)

**** chapter 7 LAB PRACTICE IT INVOLVES AD VERY APPLICABLE ******

***********FORMATTING*******
Get-Process places objects of the type System.Diagnostic.Process | Out-Default. O-D is always there it's just invisible and since OUt commands rarely work with objects Out-Default passes it to the formatting table at  dotnettypes.format.ps1xml. It uses these instructions to format the table for out-host which displays it on the monitor (host)
WIn32_OperatingSYstem PRoperties:
1)PSSTatus
2)Free
3)PSstandardMEmbers

Get-Service | Sort-Object Status | Format-Table -groupBy Status
-GroupBy generates new column headers each time the specified property value changes
Get-Service | Format-Table Name,Status,DisplayName -autoSize -wrap
Information that is cut off (truncated) will have elipses. Awkward table but more data preserved
Format-Wide or Fw displays a singular list in all detail. Grab's the object's name property
Get-Service | Format-Table @{l='ServiceName';e={$_.Name}},Status,DisplayName # this provides a column header that's different from the property name IN this case ServiceNAme.

Get-Process | Format-Table Name, @{1='VM(MB)';e={$_.VM / 1MB -as [int]}} -autosize
Get-Process | Format-Table Name, @{l='VM(MB)';e={$_.VM / 1MB -as [int]}} -autosize
                            ### Creates custom VM column and divides by 1MB with -as sets to integer (as opposed to floating point)


GRidViews out-Gridviews is not a formatting. No format table is used. Can only receive object output from other cmdlets

Get-EventLog -List | Format-Table @{n='LogName';e={$_.LogDisplayName}},@{n='RetDays';e={$_.MinimumRetentionDays}}
Get-Service | Sort-Object -Property Status -Descending | Format-Table -GroupBy Status
Get-ChildItem C:\ -Directory | Format-Wide -Column 4

FIltering

Filter Left will take a lot of knowledge and time. KEep practicing. Keeping all the filters on the left means you'll need to know which parameters and flags each cmdlet uses for filtering. When you don't know you use Where-Object (WHere) which uses generic syntax to filter any kind of object. Where-Object uses comaprison operators so remember those < > == += LEt's go over PS' version
-eq Equality as in 5 -eq 5 or "hello" -eq "help" (which one is true, which one is false?)
-ne Not equal
-ge and -le greater than or equal to or lesser than and equal to.
-gt and -lt Greater than and less than.
-and -or booleans are accepted. 
