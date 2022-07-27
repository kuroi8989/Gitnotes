COmpare-Object 0r diff
-ReferenceObject <System.Management.Automation.PSObject[]>
-DifferenceObject <PSObject>
-Property <System.Object[]>

Diff -reference (Import-CLIXML reference.xml)
  -difference (Get-Process) -property Name

  #Export implies that you're taking data and converting it to another format than saving it in storage. 
  #COnvertTo on the other hand does not save it thus not requiring a line
  Get-SErvice | ConvertTo-HTML | Out-File  


  $baseServer="C:\Store\PS\referrencexml.xml"
$Server2Compare="C:\Store\PS\differencexml.xml"

$boutput = Compare-Object -ReferenceObject (Get-Content -Path "$baseServer") 
  -DifferenceObject (Get-Content -Path "$Server2Compare")