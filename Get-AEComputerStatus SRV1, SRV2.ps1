Get-AEComputerStatus SRV1, SRV2
Get-Content servers.txt | Get-AEComputerStatus -credential company\administrator (Get-ADComputer -filter *).name | Get-AEComputerStatus -ErrorLogFilePath err.-ErrorLogFilePath
Get-AEComputerStatus    -Computername SRV1,SRV2,SRV3
                        -Credential "company\administrator"
                        -ErrorLogFilePath "statuserror.txt"
                        -ErrorAppend

Import-CSV servers.csv } Get-AEComputerStatus -credential $cred
Export-CSV status.csv

Get-Content groupl.txt | Get-AEComputerStatus |
ConverTo-HTML <parameters>

Get-AEComputerStatus (Get-ADComputer -filter *).name |
Sort-Object Computername |
Format-Table -GroupBy Computername -property Date,Uptime,Pct* |
Out-File report.txt

New-PSDrive -name DEMO -psprovider FileSystem -root \\Server\Share\Folder

#####parameters and it's strangeness with PS
$exe = "C:\VMware\vcbMounter.exe"
$host = "server"
$user = "Joe"
$password = "password"
$machine = "somepc"
$location = "somelocation"
$backupTtype = "incremental"
& $exe -h $host -u $user -p $password -s "name:$machine" -r $location -t $backupTtype
# This above suppose s that you have an external command names vcbMounter.exe We've set up all the
# various elements (executable path, name as well as all parameter values) into placeholders which start
# with the $ symbol. This allows powershell to read it more readily. PowerShell sees them as single units
# rather than find any commands or special characters within.


# Most commands can work in a variety of different ways, depending on what you need
# them to do. For example, here’s the syntax section for the Get-EventLog help:
# SYNTAX
# Get-EventLog [-AsString] [-ComputerName <string[]>] [-List] [<Com
# monParameters>]
# Get-EventLog [-LogName] <string> [[-InstanceId] <Int64[]>] [-Afte
# r <DateTime>] [-AsBaseObject] [-Before <DateTime>] [-ComputerName
# <string[]>] [-EntryType <string[]>] [-Index <Int32[]>] [-Message
# <string>] [-Newest <int>] [-Source <string[]>] [-UserName <strin
# g[]>] [<CommonParameters>]
# Notice that the command is listed twice. That indicates that the command supports
# two parameter sets, there are two distinct ways in which you can use this command.
# Some of the parameters will be shared between the two sets. You’ll notice, for exam-
# ple, that both parameter sets include a -ComputerName parameter. But the two param-
# eter sets will always have at least one unique parameter that exists only in that
# parameter set. In this case, the first set supports -AsString and -List, neither of
# which are included in the second set; the second set contains numerous parameters
# that aren’t included in the first.

# You are locked in when you use a parameter that is in one of those parameter lists but not the other you are 
# locked into only those parameters. So if you use -AsString than you are confined to only use that and
# -ComputerName and -List [<CommonParameters>] is a list of the 8 common parameters available on all
# cmdlets Optional parameters are in []

# Get-EventLog [-LogName] <system.string> [[-InstanceID] <System.Int64[]>] *Int64[] means it can accept an array/collection/list of strings
#              ^Positional argument        *Square brackets around it and it's value argument
Get-EventLog Security -computer Server R2
Get-EventLog Security -computer Server-R2,DC4,Files02 *THIS IS WRONG
Get-EventLog Security -computer `Server-R2`,`Files02`

Get-EventLog Application -computer (Get-Content names.txt)

Examples for Get-EventLog
Get-EVentLog -List
Get-EventLog -LogName System -Newest 5

Get-

Compare-Object