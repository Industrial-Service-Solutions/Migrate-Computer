__subStartupGUI__: ; Label which creates the main GUI.
  DoLogging("-- Creating GUI...")
  Gui 2: New, ,Computer Migration
 ;----This Section contains the Computer Name label and field.----
  Gui 2: Font, Bold s10
  Gui 2: Add, Text,, Type in Computer Name:
  Gui 2: Font, Norm
  Gui 2: Add, Edit, Uppercase vstrComputerName,
  Gui 2: Font, Bold s10
  Gui 2: Add, Text,, Type in Username:
  Gui 2: Font, Norm
  Gui 2: Add, Edit, vstrUsername,
  Gui 2: Font, Bold s10
  Gui 2: Add, Text,, Type in Password:
  Gui 2: Font, Norm
  Gui 2: Add, Edit, vstrPassword,
 ; ;----This section contains a Drop Down Lists for Library locations and computer types.----
 ;  Gui 2: Font, Bold s10
 ;  Gui 2: Add, Text, Section, Select Branch:
 ;  Gui 2: Font, Norm
 ;  Gui 2: Add, DDL, vstrLocation, Branch...||ESA|MRL|MOM|KL|AFL|EV|JOH|ND|VAN
 ;  Gui 2: Font, Bold s10
 ;  Gui 2: Add, Text, ys, Select computer type:
 ;  Gui 2: Font, Norm
 ;  Gui 2: Add, DDL, vstrComputerRole, Computer...||Office|Frontline|Patron|Catalog
 ;----This section contains Checkbox toggles.----
  ; Gui 2: Font, Bold s10
  ; Gui 2: Add, Checkbox, Section xm vbIsWireless, This is a Wireless computer. ; Wireless check toggle.
  ; Gui 2: Add, Checkbox, vbIsVerbose, Use Verbose logging. ; Verbose logging toggle.
  ; Gui 2: Font, Norm
 ;----This Section contains Submit and Exit Buttons.----
  Gui 2: Add, Button, Section xm+50 gButtonStart w100 Default, Start
  Gui 2: Add, Button, yp xp+110 gButtonExit w100, Exit
  Gui 2: Show
  Return

MsgBox Cthuhlu! ; This should never run!

ButtonStart: ; Label for Install button. Takes user input and prepares to run installers, confirming first. (WORKS)
  Gui 2: Submit, NoHide
  GuiControl, Disable, strComputerName
  GuiControl, Disable, strUsername
  GuiControl, Disable, strPassword
  Gosub __main__
  Return

MsgBox Cthuhlu! ; This should never run!

__subExportInformation__:
  DoLogging(" ")
  DoLogging("__ __subExportInformation__")
  arrTaskList := []
  arrTaskList.Insert("powershell.exe -Command ""& { Get-Printer | Export-Csv -Path printers.csv -NoTypeInformation }""")
  arrTaskList.Insert("powershell.exe -Command ""& { Get-PSDrive | Export-Csv -Path psdrives.csv -NoTypeInformation }""")
  ; arrTaskList.Insert("powershell.exe -Command ""& { .\CredMan.ps1 -ShoCred -All | Export-Csv -Path profilecredentials.csv -NoTypeInformation }""") ; this does an export, but it's not gonna import easily...
  ; arrTaskList.Insert("powershell.exe -Command ""& { Get-Childitem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Include '*.pst' | Export-Csv -Path pstpaths.csv -NoTypeInformation}""")
  iTotalErrors += DoExternalTasks(arrTaskList)
  FileMove, printers.csv, C:\IT, 1
  FileMove, psdrives.csv, C:\IT, 1
  FileMove, profilecredentials.csv, C:\IT, 1
  FileMove, pstpaths.csv, C:\IT, 1
  Return

__subRemoveFromDomain__:
  DoLogging(" ")
  DoLogging("__ __subRemoveFromDomain__")
  arrTaskList := []
  ; arrTaskList.Insert("powershell.exe -Command ""& { Remove-Computer -Restart -Force -WorkgroupName 'WORKGROUP' -Verbose -Passthru }""")
  arrTaskList.Insert("powershell.exe -Command ""& { $password = (ConvertTo-SecureString '" . strPassword . "' -AsPlainText -Force) `; $credential = New-Object System.Management.Automation.PSCredential ('" . strUsername . "', $password) `; Remove-Computer -Restart -Force -UnjoinDomainCredential $credential -WorkgroupName 'WORKGROUP' -Verbose -Passthru }""")
  iTotalErrors += DoExternalTasks(arrTaskList)
  WinWait, Windows PowerShell credential request
  WinActivate
  ControlSend, Edit2, %strUsername%
  ControlSend, Edit3, %strPassword%
  ControlClick, Button2
  Return

GuiClose: 
2GuiClose: ; I am annoyed by the lack of ExitReasons
ButtonExit:
  ExitApp, 1