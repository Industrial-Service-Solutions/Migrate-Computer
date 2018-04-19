

MsgBox Cthuhlu! ; This should never run!

__subTaskPhaseZero__:
  DoLogging(" ")
  DoLogging("__ __subTaskPhaseZero__")

  DoLogging(".. creating folders")
  FileCreateDir, C:\IT
  FileCreateDir, C:\IT\Logs
  FileCreateDir, C:\IT\Tools
  FileCreateDir, %A_Temp%\Migrate-Computer
  FileCreateDir, %A_Temp%\Migrate-Computer\ChocolateyInstall
  FileCreateDir, %A_Temp%\Migrate-Computer\DesktopCentralAgentInstall
  FileCreateDir, %A_Temp%\Migrate-Computer\SplashtopStreamerInstall

  DoLogging(".. copying install files")
  FileInstall, install\CredMan.ps1, %A_Temp%\Migrate-Computer\CredMan\CredMan.ps1,1
  FileInstall, install\Profwiz.exe, %A_Temp%\Migrate-Computer\Profwiz\Profwiz.exe, 1
  FileInstall, install\computers_and_users.csv, %A_Temp%\Migrate-Computer\computers_and_users.csv, 1
  FileInstall, install\packages.config, %A_Temp%\Migrate-Computer\ChocolateyInstall\packages.config,1
  FileInstall, install\DesktopCentralAgent.msi, %A_Temp%\Migrate-Computer\DesktopCentralAgentInstall\DesktopCentralAgent.msi, 1
  FileInstall, install\DesktopCentralAgent.mst, %A_Temp%\Migrate-Computer\DesktopCentralAgentInstall\DesktopCentralAgent.mst, 1
  FileInstall, install\Splashtop_Streamer.msi, %A_Temp%\Migrate-Computer\SplashtopStreamerInstall\Splashtop_Streamer.msi, 1

  DoLogging(".. getting machine and username from csv")
  matched := false
  Loop, read, computers_and_users.csv 
  {
    LineNumber = %A_Index%
    Loop, parse, A_LoopReadLine, CSV
    {
      If (A_Index == 1 AND A_LoopField == A_ComputerName) {
        matched := true
      }
      If (A_Index == 2 AND matched) {
        RegWrite("REG_DWORD", "HKEY_LOCAL_MACHINE\SOFTWARE\Migrate-Computer", "strNewComputerName", A_LoopField)
      }
      If (A_Index == 3 AND matched) {
        RegWrite("REG_DWORD", "HKEY_LOCAL_MACHINE\SOFTWARE\Migrate-Computer", "strProfwizOldUsername", A_LoopField)
      }
      If (A_Index == 4 AND matched) {
        RegWrite("REG_DWORD", "HKEY_LOCAL_MACHINE\SOFTWARE\Migrate-Computer", "strProfwizNewUsername", A_LoopField)
      }
      If (A_Index == 5 AND matched) {
        RegWrite("REG_DWORD", "HKEY_LOCAL_MACHINE\SOFTWARE\Migrate-Computer", "strProfwizNewPassword", A_LoopField)
      }
    }
  }
  If (!matched) {
    DoLogging("!! no match found in computers_and_users.csv for this computer! Asking user...")
    Gosub, __subGUI__
    Return
  }

  startExecutingAgain:

  DoLogging(".. getting Chocolatey")
  DoExternalTask("@""%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command ""iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"" && SET ""PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin""")

  DoLogging(".. getting latest Powershell")
  DoExternalTask("chocolatey install %A_Temp%\Migrate-Computer\ChocolateyInstall\packages.config -yes -force")

  DoLogging(".. waiting for Windows Installer to be ready")
  waitForWindowsInstaller()

  DoLogging(".. installing Desktop Central Agent")
  RunWait, msiexec.exe /i "%A_Temp%\Deploy-Agents\DesktopCentralAgentInstall\DesktopCentralAgent.msi" TRANSFORMS="%A_Temp%\Deploy-Agents\DesktopCentralAgentInstall\DesktopCentralAgent.mst" ENABLESILENT=yes REBOOT=ReallySuppress /qn MSIRESTARTMANAGERCONTROL=Disable /lv "%A_Temp%\Deploy-Agents\DesktopCentralAgentInstall\dcagentInstaller.log", , UseErrorLevel
  
  DoLogging(".. waiting for Windows Installer to be ready")
  waitForWindowsInstaller()
  
  DoLogging(".. installing Splashtop Agent")
  RunWait, msiexec.exe /i "%A_Temp%\Deploy-Agents\SplashtopStreamerInstall\Splashtop_Streamer.msi" /norestart /qn USERINFO=dcode=%strSplashtopDeploymentCode%`,hidewindow=1 /lv "%A_Temp%\Deploy-Agents\SplashtopStreamerInstall\Splashtop_Streamer_Install.log", , UseErrorLevel
  
  DoLogging(".. waiting for Windows Installer to be ready")
  waitForWindowsInstaller()
  
  DoLogging(".. overwriting Splashtop registry entries")
  RegWrite("REG_DWORD", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server", "CSRSLogin", "2")
  RegWrite("REG_DWORD", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server", "CSRSMode", "1")
  RegWrite("REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server", "CSRSOwner", strSplashtopCSRSOwner)
  RegWrite("REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server", "CSRSTeamName", strSplashtopCSRSTeamName)
  RegWrite("REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server", "Dcode", strSplashtopDeploymentCode)
  
  DoLogging(".. restarting Splashtop Service(s)")
  DoExternalTask("powershell.exe -Command ""& { Get-Service *splashtop* | Restart-Service }""")

__subTaskPhaseOne__:
  DoLogging(" ")
  DoLogging("__ __subTaskPhaseOne__")

  DoLogging(".. gathering information from computer")
  DoExternalTask("powershell.exe -Command ""& { Get-Printer | Export-Csv -Path printers.csv -NoTypeInformation }""")
  DoExternalTask("powershell.exe -Command ""& { Get-PSDrive | Export-Csv -Path psdrives.csv -NoTypeInformation }""")
  DoExternalTask("powershell.exe -Command ""& { pushd $env:TEMP `; .\CredMan.ps1 -ShoCred -All | Export-Csv -Path profilecredentials.csv -NoTypeInformation }""") ; this does an export, but it's not gonna import easily...
  DoExternalTask("powershell.exe -Command ""& { Get-Childitem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Include '*.pst' | Export-Csv -Path pstpaths.csv -NoTypeInformation}""")
  for index, element in DoExternalTask("powershell.exe -Command ""& { $AttachedArchives = ((New-Object -Comobject Outlook.Application).GetNamespace('MAPI')).Stores | where {$_.ExchangeStoreType -match '[3]'} `; Write-Host $AttachedArchives.FilePath `; Get-Process ""*outlook*"" | Stop-Process }""") {
      ; MsgBox % "Element number " . index . " is " . element
      FileAppend, %element%, pstpaths.txt
  }

  DoLogging(".. copying files to C:\IT\Logs")
  FileMove, printers.csv, C:\IT\Logs, 1
  FileMove, psdrives.csv, C:\IT\Logs, 1
  FileMove, profilecredentials.csv, C:\IT\Logs, 1
  FileMove, pstpaths.csv, C:\IT\Logs, 1
  FileMove, pstpaths.txt, C:\IT\Logs, 1

  DoLogging(".. creating local admin account")
  DoExternalTask("net user /add " . strLocalAccountUsername . " " . strLocalAccountPassword)
  DoExternalTask("net localgroup administrators " . strLocalAccountUsername . " /add")

  DoLogging(".. creating autologon registry keys")
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "AutoAdminLogon", "1")
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultUserName", strLocalAccountUsername)
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultPassword", strLocalAccountPassword)

  For pc In ComObjGet("winmgmts:").ExecQuery("Select * from Win32_ComputerSystem") {
    If pc.PartOfDomain {
      DoLogging(".. removing from domain: " . pc.Domain)
      DoExternalTask("powershell.exe -Command ""& { $password = (ConvertTo-SecureString '" . strLocalAccountPassword . "' -AsPlainText -Force) `; $credential = New-Object System.Management.Automation.PSCredential ('" . strLocalAccountUsername . "', $password) `; Remove-Computer -Force -Credential $credential -WorkgroupName 'WORKGROUP' -Verbose -Passthru }""")
    }
  }
  
  DoLogging(".. registering script to run at logon")
  RegWrite("REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Migrate-Computer", A_ScriptFullPath . " /PHASETWO")

  DoLogging(".. restarting computer")
  DoExternalTask("powershell.exe -Command ""& { Restart-Computer -Force }")
  Return

__subTaskPhaseTwo__:
  DoLogging(" ")
  DoLogging("__ __subTaskPhaseTwo__")

  DoLogging(".. renaming machine, joining domain")
  strNewComputerName := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Migrate-Computer","strNewComputerName")
  DoExternalTask("powershell.exe -Command ""& { $password = (ConvertTo-SecureString '" . strDomainJoinAccountPassword . "' -AsPlainText -Force) `; $credential = New-Object System.Management.Automation.PSCredential ('" . strDomainJoinAccountUsername . "', $password) `; Add-Computer -Force -Credential $credential -DomainName '" . strDomain . "' -NewName '" . strNewComputerName . "' -Verbose -Passthru }""")

  DoLogging(".. registering script to run at logon")
  RegWrite("REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Migrate-Computer", A_ScriptFullPath . " /PHASETHREE")

  DoLogging(".. creating autologon registry keys")
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "AutoAdminLogon", "1")
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultUserName", strDomainLocalAdminUsername)
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultPassword", strDomainLocalAdminPassword)
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultDomainName", strDomain)

  DoLogging(".. restarting computer")
  DoExternalTask("powershell.exe -Command ""& { Restart-Computer -Force }")
  Return

__subTaskPhaseThree__:
  DoLogging(" ")
  DoLogging("__ __subTaskPhaseThree__")

  DoLogging(".. reading values from registry")
  strProfwizOldUsername := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Migrate-Computer","strProfwizOldUsername")
  strProfwizNewUsername := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Migrate-Computer","strProfwizNewUsername")
  strProfwizNewPassword := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Migrate-Computer","strProfwizNewPassword")

  DoLogging(".. migrating profile with Profwiz")
  DoExternalTask("C:\IT\Tools\Profwiz\Profwiz.exe /DOMAIN " . strDomain . " /ACCOUNT " . strProfwizNewUsername . " /LOCALACCOUNT " . strProfwizOldUsername . " /DELETE /SILENT /NOREBOOT /LOG C:\IT\Logs\Profwiz.log")

  DoLogging(".. registering script to run at logon")
  RegWrite("REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Migrate-Computer", A_ScriptFullPath . " /PHASEFOUR")

  DoLogging(".. creating autologon registry keys")
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "AutoAdminLogon", "1")
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultUserName", strProfwizNewUsername)
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultPassword", strProfwizNewPassword)
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultDomainName", strDomain)

  DoLogging(".. restarting computer")
  DoExternalTask("powershell.exe -Command ""& { Restart-Computer -Force }")
  Return

__subTaskPhaseThree__:
  DoLogging(" ")
  DoLogging("__ __subTaskPhaseFour__")

  DoLogging(".. clearing autologon registry keys")
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "AutoAdminLogon", "0")
  ; RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultUserName", strProfwizNewUsername)
  RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultPassword", " ")
  ; RegWrite("REG_SZ", "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon", "DefaultDomainName", strDomain)


  ; Re add Credentials Possibly Partially
  ; Remove MSP Stuff  
  ; Remove Old Office/Install Office 2016 Yes
  ; Setup Email Ask Mark
  ; Import C:\Users\<User>\Documents\*.PST  Probably
  ; Import *.PST from Default 
  ; Install chocolatey package  Yes
  ; Install VPN (If See list) Yes
  ; Verify Printers were copied 
  ; Verify Mapped drives were copied  Yes
  ; Verify Power Profile  Yes
  ; Verify Splashtop Install  Yes
  ; Verify DTC  Yes
  ; Verify there ERP  No
  ; Install Vipre Yes
  ; Remove User from Administrators Yes
  Return

__subGUI__: ; Label which creates the main GUI.
  Gui 2: New, ,Computer Migration
  Gui 2: Font, Bold s18
  Gui 2: Add, Text,, No match found in csv!
  Gui 2: Font, Bold s10
  Gui 2: Add, Text,, Current Computer Name:
  Gui 2: Font, Norm
  Gui 2: Add, Edit, Uppercase vstrOldComputerName, %A_ComputerName%
  GuiControl, Disable, strOldComputerName
  Gui 2: Font, Bold s10
  Gui 2: Add, Text,, Type in New Computer Name:
  Gui 2: Font, Norm
  Gui 2: Add, Edit, Uppercase vstrNewComputerName,
  Gui 2: Font, Bold s10
  Gui 2: Add, Text,, Type in Old Username:
  Gui 2: Font, Norm
  Gui 2: Add, Edit, vstrProfwizOldUsername,
  Gui 2: Font, Bold s10
  Gui 2: Add, Text,, Type in New Username:
  Gui 2: Font, Norm
  Gui 2: Add, Edit, vstrProfwizNewUsername,
  Gui 2: Add, Button, Section xm+50 gButtonStart w100 Default, Start
  Gui 2: Add, Button, yp xp+110 gButtonExit w100, Exit
  Gui 2: Show
  Return

MsgBox Cthuhlu! ; This should never run!

ButtonStart: 
  Gui 2: Submit
  GuiControl, Disable, strNewComputerName
  GuiControl, Disable, strProfwizOldUsername
  GuiControl, Disable, strProfwizNewUsername
  Goto, startExecutingAgain
  Return



GuiClose: 
2GuiClose: ; I am annoyed by the lack of ExitReasons
ButtonExit:
  ExitApp, 1