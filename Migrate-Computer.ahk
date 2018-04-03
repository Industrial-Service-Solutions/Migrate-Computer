strVersion := "1.0.1"
/*   
  Name: Deploy-Agents
  Authors: Lucas Bodnyk
  
  External Resources:
      SetACL.exe - https://helgeklein.com/setacl/ - Helge Klein

  Changelog:
    1.0.1 - Cleaned up Powershell commands. Borrowed templating from DauphinCountyLibrarySystem/Deployment. 
    1.0.0 - Initial script, proof-of-concept.
    
  TODO:
      TEST IT OUT!

*/

;================================================================================
;   AUTO-ELEVATE
;================================================================================
Loop, %0% { ; For each parameter:
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    params .= A_Space . param
  }
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
    
if not A_IsAdmin {
    If A_IsCompiled
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
    Else
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp 9999
}

;================================================================================
;   DIRECTIVES, ETC.
;================================================================================
#NoEnv ; Recommended for performance and compatibility 
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps a script running (until closed).
#SingleInstance FORCE ; automatically replaces an old version of the script

;================================================================================
;   CONFIGURATION
;================================================================================
#Include, Migrate-Computer-Credentials.ahk

;================================================================================
;   GLOBALS, ONEXIT, ETC.
;================================================================================
ValidHostnameRegex := "i)^[a-z0-9]{1}[a-z0-9-\.]{0,14}$" ; obviously this isn't a very good pattern. I don't really know what other symbols are allowed other than dash and period, so...
DllCall("AllocConsole")
FileAppend test..., CONOUT$
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")
SplitPath, A_ScriptName, , , , ScriptBasename
StringReplace, AppTitle, ScriptBasename, _, %A_SPACE%, All
OnExit("ExitFunc") ; Register a function to be called on exit
OnExit("ExitWait")

;================================================================================
;   INITIALIZATION
;================================================================================
__init__:
Try {
  Gui 1: Font,, Lucida Console
  Gui 1: Add, Edit, Readonly x10 y10 w940 h620 vConsole ; I guess not everything has to be a function...
  Gui 1: -SysMenu
  Gui 1: Show, x20 y20 w960 h640, Console Window
  DoLogging("   Console window up.",2)
} Catch {
  MsgBox failed to create console window! I can't run without console output! Dying now.
  ExitApp
}
Try {
  DoLogging("")
  DoLogging("   ********************************************************************************")
  DoLogging("   Migrate-Computer "strVersion . " initializing for machine: " A_ComputerName)
  DoLogging("   ********************************************************************************")
  DoLogging("")
} Catch  {
  MsgBox Writing to logfile failed! You probably need to check file permissions. I won't run without my log! Dying now.
  ExitApp
}

;   ================================================================================
;   STARTUP
;   ================================================================================
__startup__:
  DoLogging("")
  DoLogging("__ __startup__")
  WinMinimizeAll
  WinRestore, Console Window
  Gosub __subStartupGUI__ ; Here is where we construct the GUI and get the specific information we need
  Return ; Execution should stop here until the user submits ButtonStart

MsgBox Cthuhlu! ; This should never run!

;================================================================================
;   MAIN
;================================================================================
__main__: ; if we're running in __main__, we should have all the input we need from the user.
  DoLogging("")
  DoLogging("__ __main__")


  Gosub, __subGetPrintersAndPSDrives__

; Copy Credential Manager Probably
; Check for PST 
; Remove Domain/Reboot  Yes
; Rename/Join Domain/Reboot Yes
; Login as user/Log Out Yes
; Login with Domain Admin Yes
; Add user to Admin group Yes
; Copy Profile MADSMITH.LCL User to ISS.lcl Only Kind Of
; Reboot  Yes
; Login as User Yes
; Re add Credentials  Possibly Partially
; Remove MSP Stuff  
; Remove Old Office/Install Office 2016 Yes
; Setup Email Ask Mark
; Set 'Cached Exchange Mode' to '12 months' Probably
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

ExitApp 0
MsgBox Cthuhlu! ; This should never run!

;   ================================================================================
;   FUNCTIONS AND LABELS
;   ================================================================================
#Include, Migrate-Computer-Functions.ahk
#Include, DynamicCommand.ahk