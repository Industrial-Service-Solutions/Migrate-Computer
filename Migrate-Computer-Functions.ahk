convertHexToString(str) {
  Loop % StrLen(str)//2 {
    charInHex := SubStr(str, A_Index*2 - 1, 2)
    charInDec := Format("{:u}", "0x" . charInHex)
    retStr .= Chr(charInDec)    
  }
  Return retStr ; Return the string to the caller 
}

RegWrite(ValueType, KeyName, ValueName, Value) {
  RegWrite, %ValueType%, %KeyName% , %ValueName%, %Value%
  Return ErrorLevel
}

RegRead(KeyName, ValueName:="(Default)") {
  OutputVar := ""
  Try (
    RegRead, OutputVar, KeyName, ValueName
  )
  Return OutputVar
}

ProcessExist(Name) {
  Process,Exist,%Name%
  return Errorlevel
}

WinGet(Cmd:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="") {
  WinGet, OutputVar, %Cmd%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return %OutputVar%
}

DoExternalTasks(arrTasks) { ; Loops through an array of task commands, trying and logging each one.
  iTaskErrors := 0
  Loop % arrTasks.MaxIndex() {
    Task := arrTasks[A_Index]
    Try {
      DoLogging("** "A_WorkingDir . "> " Task)
      shell := ComObjCreate("WScript.Shell") ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
      exec := shell.Exec(ComSpec " /C " Task) ; Execute a single command via cmd.exe
      While (!exec.StdOut.AtEndOfStream) { ;read the output line by line
        DoLogging("   " exec.StdOut.ReadLine())
      }
      If (!exec.StdErr.AtEndOfStream) { ; It's important to note that this does NOT get StdErr in parallel with StdOut - if you stack four commands in a row, and the first two fail, you will get their error output AFTER the 3rd and 4th commands finish StdOut.
        iTaskErrors += 1 ; This will only count once even if you stack commands! At least my error handling counts for something again...
        DoLogging("!! STDERR:")
        While (!exec.StdErr.AtEndOfStream) {
          DoLogging("   " exec.StdErr.ReadLine())
        }
      }
      DoLogging("")
    } Catch {
      iTaskErrors += 1
      DoLogging("!! Error attempting External Task: "Task . "!")
    }
  }
  Return iTaskErrors
}

DoExternalTask(task) {
  Try {
      DoLogging("** "A_WorkingDir . "> " task)
      shell := ComObjCreate("WScript.Shell") ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
      exec := shell.Exec(ComSpec " /C " task) ; Execute a single command via cmd.exe
      While (!exec.StdOut.AtEndOfStream) { ;read the output line by line
        DoLogging("   " exec.StdOut.ReadLine())
      }
      If (!exec.StdErr.AtEndOfStream) { ; It's important to note that this does NOT get StdErr in parallel with StdOut - if you stack four commands in a row, and the first two fail, you will get their error output AFTER the 3rd and 4th commands finish StdOut.
        iTaskErrors += 1 ; This will only count once even if you stack commands! At least my error handling counts for something again...
        DoLogging("!! STDERR:")
        While (!exec.StdErr.AtEndOfStream) {
          DoLogging("   " exec.StdErr.ReadLine())
        }
      }
      DoLogging("")
    } Catch {
      iTaskErrors += 1
      DoLogging("!! Error attempting External Task: "task . "!")
    }
  Return iTaskErrors
}

DoInternalTasks(arrTasks) { ; Loops through an array of task commands, trying and logging each one.
  iTaskErrors := 0
  ; parse!
  Try {
    Loop % arrTasks.MaxIndex() {
      Task := arrTasks[A_Index]
      strParams := ""
      Loop % Task.MaxIndex() {
        Element := Task[A_Index]
        If (A_Index>1) {
          strParams := strParams . Element
        }
        If (A_Index>1 And A_Index<Task.MaxIndex()) {
          strParams := StrParams . ","
        }
      }
      Output := Task[1] . "(" . strParams . ")"
      DoLogging("** Executing Internal Task: " Output)
      Try {
        P := StrSplit(strParams, ",")
        #(Task[1], P[1], P[2], P[3], P[4], P[5], P[6], P[7], P[8], P[9], P[10], P[11], P[12], P[13], P[14], P[15], P[16], P[17], P[18], P[19])
      } Catch {
        iTaskErrors += 1
        DoLogging("!! Error attempting Internal Task: "Output . "A_LastError: " . A_LastError)
      }
    }
  } Catch {
    iTaskErrors += 1
    DoLogging("!! Error during parsing!")
  }
  Return iTaskErrors
}

waitForWindowsInstaller() {
  RunWait, Powershell.exe "Exit (Get-Eventlog -LogName `'Application`' -Source `'*MsiInstaller*`' -InstanceId 1040`,1042 -Newest 1).EventID", ,Hide
  While (ErrorLevel != 1042) {
    Sleep 100
    RunWait, Powershell.exe "Exit (Get-Eventlog -LogName `'Application`' -Source `'*MsiInstaller*`' -InstanceId 1040`,1042 -Newest 1).EventID", ,Hide
  }
}

ExitFunc(ExitReason, ExitCode) { ; Checks and logs various unusual program closures.
  Gui +OwnDialogs
  If (ExitCode == 9999) { ; this doesn't appear to work?
    DoLogging("Restarting as Admin...")
    Return 0
  }
  If (ExitReason == "Menu") Or ((ExitReason == "Exit") And (ExitCode == 1)) {
    SoundPlay *48
    MsgBox, 52, Exiting prematurely, process is not complete!`nThis will end the program.`nAre you sure you want to exit?
      IfMsgBox, No
        Return 1  ; OnExit functions must return non-zero to prevent exit.
    DoLogging("-- User initiated and confirmed process exit via A_ExitReason: Menu (System Tray) or ExitCode: 1 (GUI Controls). Dying now.")
    Return 0
  }
  If ((A_ExitReason == "Exit") And (ExitCode == 0)) {
    DoLogging("-- Received ExitCode 0, which should indicate that the process succeeded. Dying now.")
    Return 0
  }
  If ((A_ExitReason == "Exit") And (ExitCode > 1)) {
    DoLogging("-- Received ExitCode 1 or higher, which indicates that iTotalErrors was non-zero. Dying now.")
    Return 0
  }
  If (A_ExitReason In Logoff,Shutdown) {
    DoLogging("-- System logoff or shutdown in process`, dying now.")
    Return 0  
  }
  If (A_ExitReason == "Close") {
    DoLogging("!! The system issued a WM_CLOSE or WM_QUIT`, or some other unusual termination is taking place`, dying now.")
    Return 0
  }
  DoLogging("!! I am closing unusually`, with A_ExitReason: " A_ExitReason " and ExitCode: " ExitCode ", dying now.")
  ; Do not call ExitApp -- that would prevent other OnExit functions from being called.
}

ExitWait() {
  Sleep 150 ; just in case the thread needs more time to finish the log
}

DoLogging(msg, Type=3) { ; 1 logs to file, 2 logs to console, 3 does both, 10 is just a newline to file.
  global ScriptBasename, AppTitle
  If (Type == 1) {
    FileAppend, %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%.%A_MSec%%A_Tab%%msg%`n, %ScriptBasename%.log
    }
  If (Type == 2) {
    SendToConsole(msg)
    }
  If (Type == 3) {
    FileAppend, %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%.%A_MSec%%A_Tab%%msg%`n, %ScriptBasename%.log
    SendToConsole(msg)
    }
  If (Type == 10) {
    FileAppend, `n, %ScriptBasename%.log
    }  
  Sleep 50 ; Hopefully gives the filesystem time to write the file before logging again
  Return
}

SendToConsole(msg) { ; For logging to Console window.
  GuiControlGet, Console, 1:
  GuiControl, 1:, Console, %Console%%msg%`r`n
  ControlSend, Edit1, ^{End}, Console
}

WaitForPing(num) {
  shell := ComObjCreate("WScript.Shell") ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
  DoLogging("ii Pinging to determine when the wireless adapter has connected to the network")
  DoLogging("** Ping -n "num . " -w 1000 8.8.8.8")
  exec := shell.Exec(ComSpec " /C Ping -n "num . " -w 1000 8.8.8.8") ; I am just assuming that 8.8.8.8 will always be online...
  Sleep 1000 ; Give it time to get started
  While (!exec.StdOut.AtEndOfStream) { ;read the output line by line
    DoLogging("   " exec.StdOut.ReadLine())
    If InStr(exec.StdOut.ReadLine(), "Reply") { ; If we get a reply, we break early
      DoLogging("   " exec.StdOut.ReadLine()) ; hopefully this is the line with the reply.
      DoLogging("ii Received reply, we should be good to proceed.")
      DoLogging("")
      Return
    }
  }
  MsgBox, This should not have happened, but it looks like you're not connected to the wireless network. Maybe take a look at that before proceeding?
  DoLogging("")
  Return 1
}