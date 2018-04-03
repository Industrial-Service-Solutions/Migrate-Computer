; Courtesy of HotKeyIt at https://autohotkey.com/board/topic/37397-onelinecommands-execute-ahk-code-dynamically/
;example
;var := "MsgBox"
;#(var, "hey")
;######################################################################################
#(p1,p2="",p3="",p4="",p5="",p6="",p7="",p8="",p9="",p10="",p11="",p12="",p13="",p14="",p15="",p16="",p17="",p18="",p19="",p20=""){
	global
	local t, ifcount, loopcount, out, p0,count,i,remember
	If IsLabel(p1)
		GoTo % p1
	else if IsLabel(RegExReplace(p1,"[\s`,].*")){
		Loop,Parse,p1,`,%A_Space%
		{
			If A_LoopField=
				Continue
			If (remember){
				p%i%.=A_LoopField
				Continue
			}
			i++
			p%i%=%A_LoopField%
			If (SubStr(A_LoopField,0)="``" && remember=1)
				Continue
		}
		Goto, %p1%
	} else
		Return "`tCheck Syntax:" . "`t" . p1 . "," . p2 . "," . p3 . "," . p4 . "," . p5 . "," . p6 . "," . p7
				. "," . p8 . "," . p9 . "," . p10 . "," . p11 . "," . p12 . "," . p13 . "," . p14 . "," . p15 . "," . p16
				. "," . p17 . "," . p18 . "," . p19 . "," . p20 "`n"
	Return
	Return: ;enter return value for debuging
	Return A_Tab . "ErrorLevel: " . Errorlevel . "`t" . p1 . "," . p2 . "," . p3 . "," . p4 . "," . p5 . "," . p6 . "," . p7 . "," . p8 . "," . p9 . "," . p10 . "," . p11 . "," . p12 . "," . p13 . "," . p14 . "," . p15 . "," . p16 . "," . p17 . "," . p18 . "," . p19 . "," . p20 "`n"
	AT:
	AutoTrim:
	  AutoTrim, %p2%
	Return
	BI:
	BlockInput:
		BlockInput, %p2%
	Return
	C:
	Click:
		Click %p2%, %p3%, %p4%
	Return
	CW:
	ClipWait:
	  ClipWait, %p2%, %p3%
	Goto, Return
	CTRL:
	Control:
	  Control, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%
	Goto, Return
	CC:
	ControlClick:
	  ControlClick, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%
	Goto, Return
	CF:
	ControlFocus:
	  ControlFocus, %p2%, %p3%, %p4%, %p5%
	Goto, Return
	CG:
	ControlGet:
	  ControlGet, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%

	Goto, Return
	CGF:
	ControlGetFocus:
	  ControlGetFocus, %p2%, %p3%, %p4%, %p5%, %p6%

	Goto, Return
	CGP:
	ControlGetPos:
		ControlGetPos, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%, %p10%
	Return
	CMO:
	ControlMove:
		ControlMove, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%, %p10%

	Goto, Return
	CGT:
	ControlGetText:
	  ControlGetText, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%

	Goto, Return
	CS:
	ControlSend:
	  ControlSend, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%

	Goto, Return
	CSR:
	ControlSendRaw:
	  ControlSendRaw, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%
	Goto, Return
	CST:
	ControlSetText:
	  ControlSetText, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%

	Goto, Return
	CM:
	CoordMode:
	  CoordMode, %p2%, %p3%
	Return
	CR:
	Critical:
		Critical, %p2%
	Return
	DHT:
	DetectHiddenText:
	  DetectHiddenText, %p2%
	Return
	DHW:
	DetectHiddenWindows:
	  DetectHiddenWindows, %p2%
	Return
	D:
	Drive:
	  Drive, %p2%, %p3%, %p4%

	Goto, Return
	DG:
	DriveGet:
	  DriveGet, %p2%, %p3%,%p4%

	Goto, Return
	DSF:
	DriveSpaceFree:
		DriveSpaceFree, %p2%, %p3%
	Return
	ES:
	EnvSet:
	  EnvSet, %p2%, %p3%

	Goto, Return
	EG:
	EnvGet:
	  EnvGet, %p2%, %p3%
	Return
	EU:
	EnvUpdate:
	  EnvUpdate
	Goto, Return
	ESU:
	EnvSub:
	  EnvSub, %p2%, %p3%
	Return
	EA:
	EnvAdd:
	  EnvAdd, %p2%, %p3%
	Return
	ED:
	EnvDiv:
	  EnvDiv, %p2%, %p3%
	Return
	EM:
	EnvMult:
	  EnvMult, %p2%, %p3%
	Return
	E:
	Exit:
	  Exit, %p2%
	Return
	EAP:
	ExitApp:
	  ExitApp
	Return
	FA:
	FileAppend:
	  FileAppend, %p2%, %p3%
	Goto, Return
	FC:
	FileCopy:
	  FileCopy, %p2%, %p3%, %p4%
	Goto, Return
	FCD:
	FileCopyDir:
	  FileCopyDir, %p2%, %p3%, %p4%
	Goto, Return
	FCDIR:
	FileCreateDir:
	  FileCreateDir, %p2%
	Goto, Return
	FCS:
	FileCreateShortcut:
		FileCreateShortcut, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%, %p10%

	Goto, Return
	FD:
	FileDelete:
	  FileDelete, %p2%
	Goto, Return
	FGA:
	FileGetAttrib:
	  FileGetAttrib, %p2%, %p3%
	Goto, Return
	FGS:
	FileGetSize:
	  FileGetSize, %p2%, %p3%, %p4%
	Goto, Return
	FGSH:
	FileGetShortcut:
		p3:=!p3 ? "t" : p3,p4:=!p4 ? "t" : p4,p5:=!p5 ? "t" : p5,p6:=!p6 ? "t" : p6,p7:=!p7 ? "t" : p7,p8:=!p8 ? "t" : p8,p9:=!p9 ? "t" : p9
		FileGetShortcut, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%

	Goto, Return
	FGT:
	FileGetTime:
	  FileGetTime, %p2%, %p3%, %p3%
	Goto, Return
	FGV:
	FileGetVersion:
		FileGetVersion, %p2%, %p3%

	Goto, Return
	FM:
	FileMove:
	  FileMove, %p2%, %p3%, %p4%
	Goto, Return
	FMD:
	FileMoveDir:
	  FileMoveDir, %p2%, %p3%, %p4%
	Goto, Return
	FR:
	FileRead:
	  FileRead, %p2%, %p3%
	Goto, Return
	FRL:
	FileReadLine:
	  FileReadLine, %p2%, %p3%, %p4%
	Goto, Return
	FRC:
	FileRecycle:
		FileRecycle, %p2%

	Goto, Return
	FRE:
	FileRecycleEmpty:
		FileRecycleEmpty, %p2%

	Goto, Return
	FRD:
	FileRemoveDir:
		FileRemoveDir, %p2%, %p3%

	Goto, Return
	FSF:
	FileSelectFile:
	  FileSelectFile, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	FSD:
	FileSelectFolder:
	  FileSelectFolder, %p2%, %p3%, %p4%, %p5%
	Goto, Return
	FSA:
	FileSetAttrib:
	  FileSetAttrib, %p2%, %p3%, %p4%, %p5%
	Goto, Return
	FST:
	FileSetTime:
	  FileSetTime, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	FT:
	FormatTime:
	  FormatTime, %p2%, %p3%, %p4%
	Goto, Return
	GKS:
	GetKeyState:
		GetKeyState, %p2%, %p3%, %p4%
	Return
	GA:
	GroupActivate:
	  GroupActivate, %p2%, %p3%
	Return
	GADD:
	GroupAdd:
	  GroupAdd, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%
	Return
	GCL:
	GroupClose:
	  GroupClose, %p2%, %p3%
	Return
	H:
	Hotkey:
		Hotkey, %p2%, %p3%, %p4%

	Goto, Return
	GS:
	GoSub:
		GoSub, %p2%
	Return
	GT:
	GoTo:
		Goto, %p2%
	Return
	IMB:
	IfMsgBox:
	IfMsgBox, %p2%
	{
		count = 3
		Loop 18
		{
			p%A_Index% := p%count%
			count++
		}
		If IsLabel(p1)
			GoSub, %p1%
	}
	Return
	IEQ:
	INEQ:
	IG:
	IGOE:
	IL:
	ILOE:
	IIS:
	INIS:
	IWA:
	IWNA:
	IWE:
	IWNE:
	IE:
	INE:
	IfEqual:
	IfNotEqual:
	IfGreater:
	IfGreaterOrEqual:
	IfLess:
	IfLessOrEqual:
	IfInString:
	IfNotInString:
	IfWinActive:
	IfWinNotActive:
	IfWinExist:
	IfWinNotExist:
	IfExist:
	IfNotExist:
	{
	loopcount=
	If (p1 = "IfEqual" || p1 = "IEQ")
	{
		IfEqual, %p2%, %p3%
		{
			ifcount=4
			loopcount=17
			out = %p4%
			p0 -= 3
		}
		else
			Return
	}
	
	If (p1 = "IfNotEqual" || p1 = "INEQ")
	{
		IfNotEqual, %p2%, %p3%
		{
			ifcount=4
			loopcount=17
			out = %p4%
			p0 -= 3
		}
		else
			Return
	}
	
	If (p1 = "IfLess" || p1 = "IL")
	{
		IfLess, %p2%, %p3%
		{
			ifcount=4
			loopcount=17
			out = %p4%
			p0 -= 3
		}
		else
			Return
	}
	
	If (p1 = "IfLessOrEqual" || p1 = "ILOE")
	{
		IfLessOrEqual, %p2%, %p3%
		{
			ifcount=4
			loopcount=17
			out = %p4%
			p0 -= 3
		}
		else
			Return
	}
	
	If (p1 = "IfGreater" || p1 = "IG")
	{
		IfGreater, %p2%, %p3%
		{
			ifcount=4
			loopcount=17
			out = %p4%
			p0 -= 3
		}
		else
			Return
	}
	
	If (p1 = "IfGreaterOrEqual" || p1 = "IGOE")
	{
		IfGreaterOrEqual, %p2%, %p3%
		{
			ifcount=4
			loopcount=17
			out = %p4%
			p0 -= 3
		}
		else
			Return
	}
	
	If (p1 = "IfInString" || p1 = "IIS")
	{
		IfInString, %p2%, %p3%
		{
			ifcount=4
			loopcount=17
			out = %p4%
			p0 -= 3
		}
		else
			Return
	}
	
	If (p1 = "IfNotInString" || p1 = "INIS")
	{
		IfNotInString, %p2%, %p3%
		{
			ifcount=4
			loopcount=17
			out = %p4%
			p0 -= 3
		}
		else
			Return
	}
	
	If (p1 = "IfWinActive" || p1 = "IWA")
	{
		IfWinActive, %p2%, %p3%, %p4%, %p5%
		{
			ifcount=6
			loopcount=15
			out = %p6%
			p0 -= 5
		}
		else
			Return
	}
	
	If (p1 = "IfWinNotActive" || p1 = "IWNA")
	{
		IfWinNotActive, %p2%, %p3%, %p4%, %p5%
		{
			ifcount=6
			loopcount=15
			out = %p6%
			p0 -= 5
		}
		else
			Return
	}
	
	If (p1 = "IfWinExist" || p1 = "IWE")
	{
		IfWinExist, %p2%, %p3%, %p4%, %p5%
		{
			ifcount=6
			loopcount=15
			out = %p6%
			p0 -= 5
		}
		else
			Return
	}
	
	If (p1 = "IfWinNotExist" || p1 = "IWNE")
	{
		IfWinNotExist, %p2%, %p3%, %p4%, %p5%
		{
			ifcount=6
			loopcount=15
			out = %p6%
			p0 -= 5
		}
		else
			Return
	}
	
	If (p1 = "IfExist" || p1 = "IE")
	{
		IfExist, %p2%
		{
			ifcount=3
			loopcount=18
			out = %p3%
			p0 -= 2
		}
		else
			Return
	}
	If (p1 = "IfNotExist" || p1 = "INE")
	{
		IfNotExist, %p2%
		{
			ifcount=3
			loopcount=18
			out = %p3%
			p0 -= 2
		}
		else
			Return
	}
	Loop %loopcount%
	{
		p%A_Index% := p%ifcount%
		ifcount++
	}
	out =
	If loopcount =
		Return
	IsLabel(p1)
			GoSub, %p1%
	loopcount=
	Return
	}

	KW:
	KeyWait:
	  KeyWait, %p2%, %p3%
	Goto, Return
	M:
	Menu:
	  Menu, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	MC:
	MouseClick:
	  MouseClick, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%
	Return
	MCD:
	MouseClickDrag:
	  MouseClickDrag, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%
	Return
	MGP:
	MouseGetPos:
		p2:=!p2 ? "t" : p2,p3:=!p3 ? "t" : p3,p4:=!p4 ? "t" : p4,p5:=!p5 ? "t" : p5
		MouseGetPos, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	MM:
	MouseMove:
	  MouseMove, %p2%, %p3%, %p4%, %p5%
	Return
	MB:
	MsgBox:
		checkifmsgboxfull := p3 p4 p5
		IfNotEqual, checkifmsgboxfull, , SetEnv, checkifmsgboxfull, 1
		If p2 is digit
		{
			If checkifmsgboxfull = 1 
			{
					;MsgBox % p2
					If p2 < 1
						MsgBox, 0, %p3%, %p4%, %p5%
					else if p2 = 1
					{
						MsgBox, 1, %p3%, %p4%, %p5%
					}
					else if p2 = 2
					{
						MsgBox, 2, %p3%, %p4%, %p5%
					}
					else if p2 = 3
					{
						MsgBox, 3, %p3%, %p4%, %p5%
					}
					else if p2 = 4
					{
						MsgBox, 4, %p3%, %p4%, %p5%
					}
					else if p2 = 5
					{
						MsgBox, 5, %p3%, %p4%, %p5%
					}
					else if p2 = 6
					{
						MsgBox, 6, %p3%, %p4%, %p5%
					}
					else if p2 = 262144
					{
						MsgBox, 262144, %p3%, %p4%, %p5%
					}
					else if p2 = 262145
					{
						MsgBox, 262145, %p3%, %p4%, %p5%
					}
					else if p2 = 262146
					{
						MsgBox, 262146, %p3%, %p4%, %p5%
					}
					else if p2 = 262147
					{
						MsgBox, 262147, %p3%, %p4%, %p5%
					}
					else if p2 = 262148
					{
						MsgBox, 262148, %p3%, %p4%, %p5%
					}
					else if p2 = 262149
					{
						MsgBox, 262149, %p3%, %p4%, %p5%
					}
					else if p2 = 262150
					{
						MsgBox, 262150, %p3%, %p4%, %p5%
					}
			}
			else
			{
				MsgBox, %p2% %p3% %p4% %p5% %p6% %p7% %p8% %p9% %p10% %p11% %p12% %p13% %p14% %p15% %p16% %p17% %p18% %p19% %p20%
			}
		}
		else
	  {
		MsgBox, %p2% %p3% %p4% %p5% %p6% %p7% %p8% %p9% %p10% %p11% %p12% %p13% %p14% %p15% %p16% %p17% %p18% %p19% %p20%
	  }
	Return
	OE:
	OnExit:
	  OnExit, %p2%
	Return
	PGC:
	PixelGetColor:
	  PixelGetColor, %p2%, %p3%, %p4%, %p5%
	Goto, Return
	PS:
	PixelSearch:
	  PixelSearch, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%, %p10%
	Goto, Return
	PWC:
	PixelWaitColor:  ;(ByRef p2, ByRef p3, p_x1, p_y1, p_x2, p_y2, p_color, p_shades="", p_opts="", p_waitms=0, p_checkinterval="")
	{
		if (RegExMatch(p8, "i)^[0-9a-f]{6}$"))
			p8:="0x" p8
		p8_bkp:=p8
		p8:=RegExReplace(p8, "i)\bSlow\b")
		if (p8=p8_bkp)
			p8:=p8 " Fast"
		p8_bkp:=p8
		p8:=RegExReplace(p8, "i)\bBGR\b")
		if (p8=p8_bkp)
			p8:=p8 " RGB"
		if (p12="")
			p12=519
		ts:=A_TickCount
		Loop 
		{
			PixelSearch, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%, %p10%
			if (errorlevel=0 || p11 && A_TickCount-ts>=p11)
				break
			if (p11 && (A_TickCount-ts)+p12>=p11)
				p12:=(p11-(A_TickCount-ts))/2
			if (p12>19)
				Sleep, %p12%
		}
		Goto, Return
	}
	PR:
	Process:
	  Process, %p2%, %p3%, %p4%
	Goto, Return
	R:
	Run:
	  p5:=!p5 ? "t" : p5
	  Run, %p2%, %p3%, %p4%,%p5%
	Goto, Return
	RA:
	RunAs:
		If p2 =
			RunAs
		else
			RunAs, %p2%, %p3%, %p4%
	Return
	RW:
	RunWait:
		p5:=!p5 ? "t" : p5
		RunWait, %p2%, %p3%, %p4%, %p5%
	Goto, Return
	SN:
	Send:
	  Send, %p2%
	Return
	SP:
	SendPlay:
		SendPlay, %p2%
	Return
	SI:
	SendInput:
		SendInput, %p2%
	Return
	SRAW:
	SendRaw:
		SendRaw, %p2%
	Return
	SEV:
	SendEvent:
		SendEvent, %p2%
	Return
	RND:
	Random:
	  Random, %p2%, %p3%, %p4%
	Return
	SE:
	SetEnv:
	  SetEnv, %p2%, %p3%
	Return
	SF:
	SetFormat:
		SetFormat, %p2%, %p3%
	Return
	SMOD:
	SendMode:
	  SendMode, %p2%
	Return
	SKD:
	SetKeyDelay:
	  SetKeyDelay, %p2%, %p3%, %p4%
	Return
	SMD:
	SetMouseDelay:
	  SetMouseDelay, %p2%, %p3%
	Return
	STMM:
	SetTitleMatchMode:
	  SetTitleMatchMode, %p2%
	Return
	SWD:
	SetWinDelay:
	  SetWinDelay, %p2%
	Return
	SD:
	Shutdown:
	  Shutdown, %p2%
	Return
	S:
	Sleep:
	  Sleep, %p2%
	Return
	SO:
	Sort:
	  Sort, %p2%, %p3%
	  If p3 = U

	Goto, Return
	SPP:
	SplitPath:
	  p3:=!p3 ? "t" : p3,p4:=!p4 ? "t" : p4,p5:=!p5 ? "t" : p5,p6:=!p6 ? "t" : p6,p7:=!p7 ? "t" : p7
	  SplitPath, %p2%,%p3%, %p4%, %p5%, %p6%, %p7%
	Return
	SBGT:
	StatusBarGetText:
	  StatusBarGetText, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%
	Goto, Return
	SBW:
	StatusBarWait:
	  StatusBarWait, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%
	Goto, Return
	SCS:
	StringCaseSense:
	  StringCaseSense, %p2%
	Return
	SGP:
	StringGetPos:
	  StringGetPos, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	SL:
	StringLeft:
	  StringLeft, %p2%, %p3%, %p4%
	Return
	SLEN:
	StringLen:
	  StringLen, %p2%, %p3%
	Return
	SLOW:
	StringLower:
	  StringLower, %p2%, %p3%, %p4%
	Return
	SM:
	StringMid:
	  StringMid, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	SRPL:
	StringReplace:
	  StringReplace, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	SR:
	StringRight:
	  StringRight, %p2%, %p3%, %p4%
	Return
	SS:
	StringSplit:
	  StringSplit, %p2%, %p3%, %p4%, %p5%
	Return
	STL:
	StringTrimLeft:
	  StringTrimLeft, %p2%, %p3%, %p4%
	Return
	STR:
	StringTrimRight:
	  StringTrimRight, %p2%, %p3%, %p4%
	Return
	SUP:
	StringUpper:
	  StringUpper, %p2%, %p3%, %p4%
	Return
	SG:
	SysGet:
	  SysGet, %p2%, %p3%, %p4%
	Return
	TT:
	ToolTip:
	  ToolTip, %p2%, %p3%, %p4%, %p5%
	Return
	TRT:
	TrayTip:
	  TrayTip, %p2%, %p3%, %p4%, %p5%
	Return
	TR:
	Transform:
	  Transform, %p2%, %p3%, %p4%, %p5%
	Return
	UDTF:
	UrlDownloadToFile:
	  UrlDownloadToFile, %p2%, %p3%
	Goto, Return
	VSC:
	VarSetCapacity:
		VarSetCapacity(%p2%, p3, p4)
	Return
	WA:
	WinActivate:
	  WinActivate, %p2%, %p3%, %p4%, %p5%
	Return
	WAB:
	WinActivateBottom:
	  WinActivateBottom, %p2%, %p3%, %p4%, %p5%
	Return
	WC:
	WinClose:
	  WinClose, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	WGAT:
	WinGetActiveTitle:
	  WinGetActiveTitle, %p2%
	Return
	WGC:
	WinGetClass:
	  WinGetClass, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	WG:
	WinGet:
	  WinGet, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	WGP:
	WinGetPos:
	  WinGetPos, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%
	Return
	WGT:
	WinGetText:
	  WinGetText, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	WGTT:
	WinGetTitle:
	  WinGetTitle, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	WH:
	WinHide:
	  WinHide, %p2%, %p3%, %p4%, %p5%
	Return
	WK:
	WinKill:
	  WinKill, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	WMSI:
	WinMenuSelectItem:
	  WinMenuSelectItem, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%, %p10%, %p11%, %p12%
	Goto, Return
	WM:
	WinMove:
	  WinMove, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%
	Return
	WSH:
	WinShow:
	  WinShow, %p2%, %p3%, %p4%, %p5%
	Return
	WS:
	WinSet:
	  WinSet, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%
	  If (p2 = "Style" or p2 = "Exstyle" or p2 = Polygon)

	Goto, Return
	WST:
	WinSetTitle:
	  WinSetTitle, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	WW:
	WinWait:
	  WinWait, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	WWA:
	WinWaitActive:
	  WinWaitActive, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	WWC:
	WinWaitClose:
	  WinWaitClose, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	WWNA:
	WinWaitNotActive:
	  WinWaitNotActive, %p2%, %p3%, %p4%, %p5%, %p6%
	Goto, Return
	WMAX:
	WinMaximize:
	  WinMaximize, %p2%, %p3%, %p4%
	Return
	WMIN:
	WinMinimize:
	  WinMinimize, %p2%, %p3%, %p4%
	Return
	WR:
	WinRestore:
	  WinRestore, %p2%, %p3%, %p4%, %p5%
	Return
	IS:
	ImageSearch:
	  ImageSearch, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%
	Goto, Return
	ID:
	IniDelete:
	  IniDelete, %p2%, %p3%, %p4%
	Goto, Return
	IR:
	IniRead:
	  IniRead, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	IW:
	IniWrite:
	  IniWrite, %p2%, %p3%, %p4%, %p5%
	Goto, Return
	I:
	Input:
	  If p2
		Input, %p2%, %p3%, %p4%, %p5%
	  else
		Input
	Goto, Return
	IB:
	InputBox:
	  InputBox, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%, , %p11%, %p12%
	Goto, Return
	G:
	Gui:
		Gui, %p2%, %p3%, %p4%, %p5%
	Return
	GD:
	GroupDeactivate:
		GroupDeactivate, %p2%, %p3%
	Return
	GC:
	GuiControl:
		GuiControl, %p2%, %p3%, %p4%
	Goto, Return
	GuiControlGet:
		GuiControlGet, %p2%, %p3%, %p4%, %p5%
	Goto, Return
	If:
		If p3 = is
		{
			If (%p2% is %p4%)
			{
				GoTo, RunCommand
			}
		}
		else if p3 = is not
		{
			If (%p2% is not %p4%)
			{
				GoTo, RunCommand
			}
		}
		else If p3 = <
		{
			If (%p2% < %p4%)
			{
				GoTo, RunCommand
			}
		}
		else If p3 = =
		{
			If (%p2% = %p4%)
			{
				GoTo, RunCommand
			}
		}
		else If p3 = >
		{
			If %p2% > %p4%
			{
				GoTo, RunCommand
			}
		}
	Return
	RunCommand:
		count = 5
		Loop 16
		{
			p%A_Index% := p%count%
			count++
		}
		If IsLabel(p1)
			GoTo, %p1%
	Return
	KH:
	KeyHistory:
		KeyHistory
	Return
	LH:
	ListHotkeys:
		ListHotkeys
	Return
	LV:
	ListVars:
		ListVars
	Return
	OD:
	OutputDebug:
		OutputDebug, %p2%
	Return
	P:
	Pause:
		Pause, %p2%, %p3%
	Return
	PM:
	PostMessage:
		PostMessage, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%

	Goto, Return
	SMSG:
	SendMessage:
		SendMessage, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%, %p8%, %p9%

	Goto, Return
	PRG:
	Progress:
		Progress, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	SIM:
	SplashImage:
		SplashImage, %p2%, %p3%, %p4%, %p5%, %p6%, %p7%
	Return
	RD:
	RegDelete:
		Regdelete, %p2%, %p3%, %p4%

	Goto, Return
	REM:
	RegExMatch:
		RegExMatch(%p2%, %p3%, %p4%, %p5%)

	Goto, Return
	RER:
	RegExReplace:
		RegExReplace(%p2%, %p3%, %p4%, %p5%, %p6%, %p7%)

	Goto, Return
	RC:
	RegisterCallback:
		RegisterCallback(%p2%, %p3%, %p4%, %p5%)
	Return
	RR:
	RegRead:
		RegRead, %p2%, %p3%, %p4%, %p5%

	Goto, Return
	RWR:
	RegWrite:
		;RegWrite, %p2%, %p3%, %p4%, %p5%, %p6%^ ; no idea why the caret on the end
		RegWrite, %p2%, %p3%, %p4%, %p5%, %p6%

	Goto, Return
	RL:
	Reload:
		Reload
	Return
	SBL:
	SetBatchLines:
		SetBatchLines, %p2%
	Return
	SCD:
	SetControlDelay:
		SetControlDelay, %p2%
	Return
	SDMS:
	SetDefaultMouseSpeed:
		SetDefaultMouseSpeed, %p2%
	Return
	SNLS:
	SetNumLockState:
	 SetNumLockState, %p2%
	Return
	SCLS:
	SetCapsLockState:
		SetCapsLockState, %p2%
	Return
	SSLS:
	SetScrollLockState:
		SetScrollLockState, %p2%
	Return
	SSCM:
	SetStoreCapslockMode:
		SetStoreCapslockMode, %p2%
	Return
	ST:
	SetTimer:
		SetTimer, %p2%, %p3%, %p4%
	Return
	SWDIR:
	SetWorkingDir:
		SetWorkingDir, %p2%

	Goto, Return
	SB:
	SoundBeep:
		SoundBeep, %p2%, %p3%
	Return
	SOG:
	SoundGet:
		SoundGet, %p2%, %p3%, %p4%, %p5%

	Goto, Return
	SGWV:
	SoundGetWaveVolume:
		SoundGetWaveVolume, %p2%, %p3%, %p4%

	Goto, Return
	SPL:
	SoundPlay:
		SoundPlay, %p2%, %p3%

	Goto, Return
	SOS:
	SoundSet:
		SoundSet, %p2%, %p3%, %p4%, %p5%

	Goto, Return
	SSWV:
	SoundSetWaveVolume:
		SoundSetWaveVolume, %p2%, %p3%

	Goto, Return
	STOF:
	SplashTextOff:
		SplashTextOff
	Return
	STON:
	SplashTextOn:
		SplashTextOn, %p2%, %p3%, %p4%, %p5% 
	Return
	SU:
	Suspend:
		Suspend, %p2%
	Return
	T:
	Thread:
		Thread, %p2%, %p3%
	Return
	WGAS:
	WinGetActiveStats:
		WinGetActiveStats, %p2%, %p3%, %p4%, %p5%, %p6%
	Return
	WMA:
	WinMinimizeAll:
		WinMinimizeAll
	Return
	WMAU:
	WinMinimizeAllUndo:
		WinMinimizeAllUndo
	Return
}