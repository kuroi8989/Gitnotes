$wsh = New-Object -ComObject WScript.Shell
while (1) {
  $wsh.SendKeys('+{15}')
  Start-Sleep -seconds 59
  }