
#cs ===============================================================================
	*XProTec - Free Version f1.0.0 - 04.09.2007
	Autor: 		Robert M @ QT Appraisal
	E-mail:		Valuater@aol.com
	Language:    English
	OSystem: 	Windows Xp
	Features: 	-Automated Program
				-Register Users
				-Receive Payment
				-Program Protection
	Requirements: Legal copy of Microsoft Windows Xp
	Construction: AutoIt 3.2.2.0+, SciTE 1.73
	
	Thanks to all, Enjoy...
#ce ===============================================================================

#cs Demo Use
;#include<XProTec.au3> ; MUST BE AN INCLUDE

$D_Mail = "developer@msn.com " ; your email
$D_Program = "XPro-Tec-Free" ; your program name
$U_Price = "20.00" ; the amount of money you wish to be payed by the user
$U_Trial = "30" ; amount of days for the trial period
$U_License = "3" ; 3 = one computer only - see license notes
$D_License = "1" ; developers license #
$D_PayPal = "www.paypal.com/my account-link to paypal" ; - paypal link
$D_Link = "www.mywebsite.com/.../" ; looks for "www.mywebsite.com/.../Blacklist.txt" ; see Blacklist
$U_Return = 1 ; pay or quit .... or  $U_Return = 0 ; will return control to developer with @extended = 6 [Limited Freeware Option]

XProTec($D_Mail, $D_Program, $U_Price, $U_Trial, $U_License, $D_License, $D_PayPal, $D_Link, $U_Return)

; your script starts here ..............

#ce End Demo


#include-once

Global $smtpserver = "YOUR_SERVER"
Global $sendusername = "YOUR_SERVER_USER_NAME"
Global $sendpassword = "YOUR_SERVER_USERS_PASSWORD"
; Info for this function by JdeB = http://www.autoitscript.com/forum/index.php?s=&showtopic=23860&view=findpost&p=166575

Func XProTec($D_Mail, $D_Program, $U_Price = 0, $U_Trial = 0, $U_License = 1, $D_License = 1, $D_PayPal = 1, $D_Link = 1, $U_Return = 1)
	If @Compiled <> 1 and $D_License <> 1 Then Return SetError(1, -1, "Not a Compiled Program")
	If $D_Program <> StringTrimRight(@ScriptName, 4) Then mError("ERROR - Not a Valid Program Name     ", 1, 1)
	Local $i_rand, $U_info, $Vreg, $U_Payed, $rtemp = @TempDir & "\XTemp.txt", $M_server = "@ClickTask.com", $ND_Mail = $D_Mail, $encrypt = "Fudge", $ver = "f1.0.0"
	Local $P_program = $D_Program, $sC = @ComputerName, $sD = @HomeDrive, $R_owner = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "RegisteredOwner"), $sS = @ScriptName
	Local $D_1 = _StringEncryptor(1, $D_Mail, $encrypt), $D_2 = _StringEncryptor(1, "X" & (StringInStr($D_Mail, "@") * (StringLen($D_Mail) - 2)) + ((StringLen($D_Mail) - 2) * 7) , (StringLen($D_1) - 9))
	Local $rand = Chr(Random(Asc("A"), Asc("Z"), 1)) & Random(100, 999, 1) & "-" & Chr(Random(Asc("A"), Asc("Z"), 1)) & Random(100, 999, 1) & "-" & Chr(Random(Asc("A"), Asc("Z"), 1)) & Random(100, 999, 1) & "-" & Chr(Random(Asc("A"), Asc("Z"), 1)) & Random(100, 999, 1)
	Local $P_3 = StringMid( _StringEncryptor(1, "X" & (StringLeft(DriveGetSerial($sD), 6) + StringLen($sC)) & StringLen($sC), $encrypt & "n", 2), StringLen($sC) / 2, 16), $F_days = 0, $F_file = @SystemDir & "\winopsys.dat"
	If StringInStr($sS, "XProTec") Then Return mError("Not a Valid Developer Program   ", 2, 1)
	If Not StringInStr($D_Mail, "@") And Not StringInStr($D_Mail, ".") Then Return mError("Not a Valid Developer Email   ", 3, 1)
	If $U_License <> 1 And $U_License <> 2 And $U_License <> 3 Then Return mError("Not a Valid User License Number (1,2 or 3)   ", 4, 1)
	If $D_License <> $D_2 Then mError("Please Register as Developer" & @CRLF & @CRLF & "Dev Email = " & $D_Mail & "   "  & @CRLF & "Dev License = " & $D_2 & "     " & @CRLF & @CRLF, " Free #          ...Valuater", 1) 
	While 1
		If Ping("www.Autoit3.com", 4000) > 0 Then ExitLoop
		If MsgBox(262149, "Connection Error", "An Internet Connection is Required     ", 10) = 2 Then Exit
	WEnd
	$X_read001 = RegRead("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "001")
	$X_read004 = RegRead("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "004")
	If $X_read001 = "" And $X_read004 = "" Then
		If MsgBox(262209, $P_program, "To Register as User, an Email will be sent Immediately to you  " & @CRLF & @CRLF & "Please Click OK to continue   " & @CRLF) <> 1 Then Exit
		Do
			$U_Mail = Qbox($P_program, "Please Type in your Email Address   " & @CRLF & @CRLF & "If not, you will need to restart -  " & $P_program & "   ")
		Until StringInStr($U_Mail, "@") And StringInStr($U_Mail, ".")
		$text = "Please copy the Validation Code below" & @CRLF & @CRLF & "Owner = " & $R_owner & @CRLF & "Program = " & $P_program & @CRLF & _
				"Validation Date = " & _DateTimeFormat( _NowCalc(), 1) & @CRLF & "Validation Code = " & $rand & @CRLF & @CRLF & " Thank You!" & @CRLF & $P_program
		mEmailer($P_program & $M_server, $U_Mail, $ND_Mail, $P_program & " Validation Code", $text)
		Do
			$input1 = Qbox($P_program, "Please Copy and Paste the Validation Code from the Email here  " & @CRLF & "If not, you will need to restart - " & $P_program & "   ")
		Until $input1 = $rand
		Local $X_read003 = $U_Mail, $X_read004 = _NowCalc(), $X_read005 = "", $X_read006 = "", $X_read007 = ""
		IniWrite($F_file, "Security", $P_program, _StringEncryptor(1, _NowCalc() , (StringLen($D_1) - 13)))
		RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "001", "REG_SZ", $D_Mail)
		If $D_License <> $D_2 Then RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "002", "REG_SZ", "Developer Not Licensed")
		If $D_License = $D_2 Then RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "002", "REG_SZ", "Licensed Developer")
		RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "003", "REG_SZ", $U_Mail)
		RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "004", "REG_SZ", _StringEncryptor(1, _NowCalc() , (StringLen($D_1) - 13)))
		RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "005", "REG_SZ", "")
		RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "006", "REG_SZ", "")
		RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "007", "REG_SZ", "")
	Else
		If $X_read001 <> $D_Mail Then mError("Not the Registered Developer Email  ", 5, 1)
		If $D_License <> $D_2 Then RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "002", "REG_SZ", "Developer Not Licensed")
		If $D_License = $D_2 Then RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "002", "REG_SZ", "Licensed Developer")
		$X_read003 = RegRead("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "003")
		$X_read004 = _StringEncryptor(0, RegRead("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "004") , (StringLen($D_1) - 13))
		$X_read005 = _StringEncryptor(0, RegRead("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "005"), $encrypt & "7")
		$X_read006 = _StringEncryptor(0, RegRead("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "006"), $encrypt & "2")
		$X_read007 = RegRead("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "007")
	EndIf
	If InetGet($D_Link & "Blacklist.txt", $rtemp, 1) = 1 Then
		$itemp = FileRead($rtemp)
		FileDelete($rtemp)
		If StringInStr($itemp, $X_read003) Or StringInStr($itemp, $ND_Mail) Then mError("This program has been abused and will now close    ", 6, 1)
	EndIf
	If $U_Trial = 0 And $U_Price = 0 Then Return SetError(0, 0, "Free Licensed")
	If $U_License = 1 And $X_read005 = $X_read003 Then Return SetError(0, 1, "Email Licensed")
	If $U_License = 2 And $X_read006 = $R_owner Then Return SetError(0, 2, "Owner Licensed")
	If $U_License = 3 And $X_read007 = $P_3 Then Return SetError(0, 3, "Computer Licensed")
	If $U_License = 1 Then $U_info = "Your E-Mail   "
	If $U_License = 1 Then $i_rand = _StringEncryptor(1, $X_read003, $encrypt & "7")
	If $U_License = 2 Then $U_info = "Windows Registered Owner  "
	If $U_License = 2 Then $i_rand = _StringEncryptor(1, $R_owner, $encrypt & "2")
	If $U_License = 3 Then $U_info = "One Computer Only  "
	If $U_License = 3 Then $i_rand = $P_3
	$T_days = _DateDiff("D", $X_read004, _NowCalc())
	$t = FileGetTime(_StringEncryptor(0, IniRead($F_file, "Security", $P_program, _NowCalc()) , (StringLen($D_1) - 13)))
	If Not @error Then $F_days = _DateDiff("D", $t[0] & "/" & $t[1] & "/" & $t[2], _NowCalc())
	If $F_days > $T_days Then $T_days = $F_days
	If $T_days < 0 Or $T_days > 3600 Then mError("ERROR - Validation Date   ", 7, 1)
	If $D_License <> $D_2 And $T_days > 90 Then mError("Developer Trial Period has Expired  ", 9, 1)
	If $U_Trial <> 0 And $U_Price = 0 And $T_days > $U_Trial Then mError($P_program & "'s Trial Period has Expired  ", 8, 1)
	If $U_Trial <> 0 And $T_days > ($U_Trial / 2) And $T_days <= $U_Trial Then $U_Payed = mRegister($P_program, $U_Price, $U_Trial, $U_License, $T_days, $D_PayPal, $U_info, $i_rand, 0)
	If $U_Trial = 0 And $U_Price <> 0 Or $T_days > $U_Trial Then $U_Payed = mRegister($P_program, $U_Price, $U_Trial, $U_License, $T_days, $D_PayPal, $U_info, $i_rand, $U_Return)
	If $U_Payed = 1 And $U_License >= 1 And $U_License <= 3 Then RegWrite("HKCU\Software\Microsoft\Windows\Current Version\Settings\ClickTask.com\X-" & $P_program, "00" & ($U_License + 4), "REG_SZ", $i_rand)
	If $U_Payed = 1 Then $text = "Please save this Registration Code Page" & @CRLF & @CRLF & "Owner = " & $R_owner & @CRLF & "Program = " & $P_program & @CRLF & _
			"Registration Date = " & _DateTimeFormat( _NowCalc(), 1) & @CRLF & "Registration Code = " & $i_rand & @CRLF & @CRLF & " Thank You!" & @CRLF & $P_program
	If $U_Payed = 1 Then mEmailer($P_program & $M_server, $X_read003, $ND_Mail, $P_program & " Registration Code", $text)
	If $U_Payed = 1 Then MsgBox(64, $P_program, " You are now registered and a confirmation email has been sent to you  " & @CRLF & @CRLF & "..... Thank You !      ", 5)
	If $U_Payed = 1 Then Return SetError(0, 4, "License Paid")
	If $U_Trial = 0 And $U_Price <> 0 Or $T_days > $U_Trial Then Return SetError(0, 6, "Freeware Limited")
	Return SetError(0, 5, "License Not Paid")
EndFunc   ;==>XProTec
Func mRegister($Prog, $U_P, $U_T, $U_L, $T_D, $D_P, $Uinfo, $irand, $rFatal = 0)
	Local $PR1 = "Trial Period = " & $U_T & " Days  " & @CRLF & "License Type = " & $Uinfo & @CRLF & "Register Fee =  $" & $U_P
	Local $PR2 = "   " & @CRLF & "Days Since Validation = " & $T_D & @CRLF & @CRLF & "Would you like to Register Now?      " & @CRLF & @CRLF
	Local $PR3 = "*Yes*  to Register Now!" & @CRLF & "*No*  to use your previous Registration Number.      " & @CRLF & "*Cancel*  to Quit Registration." & @CRLF
	$U_ans = MsgBox(262147, $Prog, $PR1 & $PR2 & $PR3)
	If $U_ans = 6 Then
		WinMinimizeAll()
		$PID = Run('C:\Program Files\Internet Explorer\iexplore.exe "' & $D_P & '"', "", @SW_SHOW)
		WinWaitActive("")
		Local $Handle = WinGetHandle($PID), $sHTML = "", $loop = 0
		While ProcessExists($PID)
			Sleep(3000)
			If ProcessExists($PID) = 0 Then ExitLoop
			If Not StringInStr(WinGetTitle($Handle), "PayPal") And Not StringInStr(WinGetTitle($Handle), "DreamHost") Then
				If $loop = 5 Then ExitLoop
				$loop = $loop + 1
			Else
				$loop = 0
			EndIf
			If StringInStr(WinGetTitle($Handle), "Thank you for your payment") Then Return 1
		WEnd
		ProcessClose($PID)
	EndIf
	If $U_ans = 7 Then
		Do
			$input1 = Qbox($Prog, "Please Paste your Registration Code below       " & @CRLF & "License Type = " & $Uinfo & "   " & @CRLF & "If not, you will need to restart - " & $Prog & "   ")
		Until $input1 = $irand
		Return 1
	EndIf
	If $rFatal Then	Exit
	Return 0
EndFunc   ;==>mRegister
Func mEmailer($e_Sender, $e_Recipient, $e_CcAddress, $e_Subject, $e_Text)
	; Info for this function by JdeB = http://www.autoitscript.com/forum/index.php?s=&showtopic=23860&view=findpost&p=166575
	$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	$objMessage = ObjCreate("CDO.Message")
	With $objMessage
		.Subject = $e_Subject
		.Sender = $e_Sender
		.From = $e_Sender
		.To = $e_Recipient
		.Cc = $e_CcAddress
		.TextBody = $e_Text
	EndWith
	With $objMessage.Configuration.Fields
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $smtpserver
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $sendusername
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $sendpassword
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
		.Update
	EndWith
	$objMessage.Send
	If @error Then MyErrFunc()
	$oMyError = ""
	$objMessage = ""
EndFunc   ;==>mEmailer
Func Qbox($t1, $L1)
	$Qbox = InputBox($t1, $L1, "", "", 300, 150)
	If @error = 1 Then Exit
	Return $Qbox
EndFunc   ;==>Qbox
Func mError($sText, $ret = 0, $iFatal = 0)
	MsgBox(48 + 4096 + 262144, "*XProTec*", $sText & " #" & $ret & "   ")
	If $iFatal Then Exit
EndFunc   ;==>mError
Func MyErrFunc()
	MsgBox(262209, "COM / Internal Error", "This Program has been interupted by a Fatal COM Error      ")
	Exit
EndFunc   ;==>MyErrFunc
Func _INetGetSources($s_URL, $s_Header = '')
	If StringLeft($s_URL, 7) <> 'http://' And StringLeft($s_URL, 8) <> 'https://' Then $s_URL = 'http://' & $s_URL
	Local $h_DLL = DllOpen("wininet.dll"), $ai_IRF, $s_Buf = ''
	Local $ai_IO = DllCall($h_DLL, 'int', 'InternetOpen', 'str', "AutoIt v3", 'int', 0, 'int', 0, 'int', 0, 'int', 0)
	If @error Or $ai_IO[0] = 0 Then
		DllClose($h_DLL)
		SetError(1)
		Return ""
	EndIf
	Local $ai_IOU = DllCall($h_DLL, 'int', 'InternetOpenUrl', 'int', $ai_IO[0], 'str', $s_URL, 'str', $s_Header, 'int', StringLen($s_Header), 'int', 0x80000000, 'int', 0)
	If @error Or $ai_IOU[0] = 0 Then
		DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])
		DllClose($h_DLL)
		SetError(1)
		Return ""
	EndIf
	Local $v_Struct = DllStructCreate('udword')
	DllStructSetData($v_Struct, 1, 1)
	While DllStructGetData($v_Struct, 1) <> 0
		$ai_IRF = DllCall($h_DLL, 'int', 'InternetReadFile', 'int', $ai_IOU[0], 'str', '', 'int', 256, 'ptr', DllStructGetPtr($v_Struct))
		$s_Buf &= StringLeft($ai_IRF[2], DllStructGetData($v_Struct, 1))
	WEnd
	DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IOU[0])
	DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])
	DllClose($h_DLL)
	Return $s_Buf
EndFunc   ;==>_INetGetSources
Func _StringEncryptor($i_Encrypt, $s_EncryptText, $s_EncryptPassword, $i_EncryptLevel = 1)
	If $i_Encrypt <> 0 And $i_Encrypt <> 1 Then
		SetError(1)
		Return ''
	ElseIf $s_EncryptText = '' Or $s_EncryptPassword = '' Then
		SetError(1)
		Return ''
	Else
		If Number($i_EncryptLevel) <= 0 Or Int($i_EncryptLevel) <> $i_EncryptLevel Then $i_EncryptLevel = 1
		Local $v_EncryptModified, $i_EncryptCountH, $i_EncryptCountG, $v_EncryptSwap, $av_EncryptBox[256][2], $i_EncryptCountA
		Local $i_EncryptCountB, $i_EncryptCountC, $i_EncryptCountD, $i_EncryptCountE, $v_EncryptCipher, $v_EncryptCipherBy
		If $i_Encrypt = 1 Then
			For $i_EncryptCountF = 0 To $i_EncryptLevel Step 1
				$i_EncryptCountG = ''
				$i_EncryptCountH = ''
				$v_EncryptModified = ''
				For $i_EncryptCountG = 1 To StringLen($s_EncryptText)
					If $i_EncryptCountH = StringLen($s_EncryptPassword) Then
						$i_EncryptCountH = 1
					Else
						$i_EncryptCountH = $i_EncryptCountH + 1
					EndIf
					$v_EncryptModified = $v_EncryptModified & Chr(BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountG, 1)), Asc(StringMid($s_EncryptPassword, $i_EncryptCountH, 1)), 255))
				Next
				$s_EncryptText = $v_EncryptModified
				$i_EncryptCountA = ''
				$i_EncryptCountB = 0
				$i_EncryptCountC = ''
				$i_EncryptCountD = ''
				$i_EncryptCountE = ''
				$v_EncryptCipherBy = ''
				$v_EncryptCipher = ''
				$v_EncryptSwap = ''
				$av_EncryptBox = ''
				Local $av_EncryptBox[256][2]
				For $i_EncryptCountA = 0 To 255
					$av_EncryptBox[$i_EncryptCountA][1] = Asc(StringMid($s_EncryptPassword, Mod($i_EncryptCountA, StringLen($s_EncryptPassword)) + 1, 1))
					$av_EncryptBox[$i_EncryptCountA][0] = $i_EncryptCountA
				Next
				For $i_EncryptCountA = 0 To 255
					$i_EncryptCountB = Mod(($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
					$v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
					$av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
					$av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
				Next
				For $i_EncryptCountA = 1 To StringLen($s_EncryptText)
					$i_EncryptCountC = Mod(($i_EncryptCountC + 1), 256)
					$i_EncryptCountD = Mod(($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
					$i_EncryptCountE = $av_EncryptBox[Mod(($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256)][0]
					$v_EncryptCipherBy = BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountA, 1)), $i_EncryptCountE)
					$v_EncryptCipher = $v_EncryptCipher & Hex($v_EncryptCipherBy, 2)
				Next
				$s_EncryptText = $v_EncryptCipher
			Next
		Else
			For $i_EncryptCountF = 0 To $i_EncryptLevel Step 1
				$i_EncryptCountB = 0
				$i_EncryptCountC = ''
				$i_EncryptCountD = ''
				$i_EncryptCountE = ''
				$v_EncryptCipherBy = ''
				$v_EncryptCipher = ''
				$v_EncryptSwap = ''
				$av_EncryptBox = ''
				Local $av_EncryptBox[256][2]
				For $i_EncryptCountA = 0 To 255
					$av_EncryptBox[$i_EncryptCountA][1] = Asc(StringMid($s_EncryptPassword, Mod($i_EncryptCountA, StringLen($s_EncryptPassword)) + 1, 1))
					$av_EncryptBox[$i_EncryptCountA][0] = $i_EncryptCountA
				Next
				For $i_EncryptCountA = 0 To 255
					$i_EncryptCountB = Mod(($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
					$v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
					$av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
					$av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
				Next
				For $i_EncryptCountA = 1 To StringLen($s_EncryptText) Step 2
					$i_EncryptCountC = Mod(($i_EncryptCountC + 1), 256)
					$i_EncryptCountD = Mod(($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
					$i_EncryptCountE = $av_EncryptBox[Mod(($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256)][0]
					$v_EncryptCipherBy = BitXOR(Dec(StringMid($s_EncryptText, $i_EncryptCountA, 2)), $i_EncryptCountE)
					$v_EncryptCipher = $v_EncryptCipher & Chr($v_EncryptCipherBy)
				Next
				$s_EncryptText = $v_EncryptCipher
				$i_EncryptCountG = ''
				$i_EncryptCountH = ''
				$v_EncryptModified = ''
				For $i_EncryptCountG = 1 To StringLen($s_EncryptText)
					If $i_EncryptCountH = StringLen($s_EncryptPassword) Then
						$i_EncryptCountH = 1
					Else
						$i_EncryptCountH = $i_EncryptCountH + 1
					EndIf
					$v_EncryptModified = $v_EncryptModified & Chr(BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountG, 1)), Asc(StringMid($s_EncryptPassword, $i_EncryptCountH, 1)), 255))
				Next
				$s_EncryptText = $v_EncryptModified
			Next
		EndIf
		Return $s_EncryptText
	EndIf
EndFunc   ;==>_StringEncryptor
Func _NowCalc()
	Return (@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
EndFunc   ;==>_NowCalc
Func _DateTimeFormat($sDate, $sType)
	Local $asDatePart[4]
	Local $asTimePart[4]
	Local $sTempDate = ""
	Local $sTempTime = ""
	Local $sAM
	Local $sPM
	Local $iWday
	Local $lngX
	If Not _DateIsValid($sDate) Then
		SetError(1)
		Return ("")
	EndIf
	If $sType < 0 Or $sType > 5 Or Not IsInt($sType) Then
		SetError(2)
		Return ("")
	EndIf
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)
	Switch $sType
		Case 0
			$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1F, "str", "", "long", 255)
			If Not @error And $lngX[0] <> 0 Then
				$sTempDate = $lngX[3]
			Else
				$sTempDate = "M/d/yyyy"
			EndIf
			If $asTimePart[0] > 1 Then
				$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1003, "str", "", "long", 255)
				If Not @error And $lngX[0] <> 0 Then
					$sTempTime = $lngX[3]
				Else
					$sTempTime = "h:mm:ss tt"
				EndIf
			EndIf
		Case 1
			$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x20, "str", "", "long", 255)
			If Not @error And $lngX[0] <> 0 Then
				$sTempDate = $lngX[3]
			Else
				$sTempDate = "dddd, MMMM dd, yyyy"
			EndIf
		Case 2
			$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1F, "str", "", "long", 255)
			If Not @error And $lngX[0] <> 0 Then
				$sTempDate = $lngX[3]
			Else
				$sTempDate = "M/d/yyyy"
			EndIf
		Case 3
			If $asTimePart[0] > 1 Then
				$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1003, "str", "", "long", 255)
				If Not @error And $lngX[0] <> 0 Then
					$sTempTime = $lngX[3]
				Else
					$sTempTime = "h:mm:ss tt"
				EndIf
			EndIf
		Case 4
			If $asTimePart[0] > 1 Then
				$sTempTime = "hh:mm"
			EndIf
		Case 5
			If $asTimePart[0] > 1 Then
				$sTempTime = "hh:mm:ss"
			EndIf
	EndSwitch
	If $sTempDate <> "" Then
		$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1D, "str", "", "long", 255)
		If Not @error And $lngX[0] <> 0 Then
			$sTempTime = StringReplace($sTempTime, "/", $lngX[3])
		EndIf
		$iWday = _DateToDayOfWeek($asDatePart[1], $asDatePart[2], $asDatePart[3])
		$asDatePart[3] = StringRight("0" & $asDatePart[3], 2)
		$asDatePart[2] = StringRight("0" & $asDatePart[2], 2)
		$sTempDate = StringReplace($sTempDate, "d", "@")
		$sTempDate = StringReplace($sTempDate, "m", "#")
		$sTempDate = StringReplace($sTempDate, "y", "&")
		$sTempDate = StringReplace($sTempDate, "@@@@", _DateDayOfWeek($iWday, 0))
		$sTempDate = StringReplace($sTempDate, "@@@", _DateDayOfWeek($iWday, 1))
		$sTempDate = StringReplace($sTempDate, "@@", $asDatePart[3])
		$sTempDate = StringReplace($sTempDate, "@", StringReplace(StringLeft($asDatePart[3], 1), "0", "") & StringRight($asDatePart[3], 1))
		$sTempDate = StringReplace($sTempDate, "####", _DateMonthOfYear($asDatePart[2], 0))
		$sTempDate = StringReplace($sTempDate, "###", _DateMonthOfYear($asDatePart[2], 1))
		$sTempDate = StringReplace($sTempDate, "##", $asDatePart[2])
		$sTempDate = StringReplace($sTempDate, "#", StringReplace(StringLeft($asDatePart[2], 1), "0", "") & StringRight($asDatePart[2], 1))
		$sTempDate = StringReplace($sTempDate, "&&&&", $asDatePart[1])
		$sTempDate = StringReplace($sTempDate, "&&", StringRight($asDatePart[1], 2))
	EndIf
	If $sTempTime <> "" Then
		$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x28, "str", "", "long", 255)
		If Not @error And $lngX[0] <> 0 Then
			$sAM = $lngX[3]
		Else
			$sAM = "AM"
		EndIf
		$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x29, "str", "", "long", 255)
		If Not @error And $lngX[0] <> 0 Then
			$sPM = $lngX[3]
		Else
			$sPM = "PM"
		EndIf
		$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1E, "str", "", "long", 255)
		If Not @error And $lngX[0] <> 0 Then
			$sTempTime = StringReplace($sTempTime, ":", $lngX[3])
		EndIf
		If StringInStr($sTempTime, "tt") Then
			If $asTimePart[1] < 12 Then
				$sTempTime = StringReplace($sTempTime, "tt", $sAM)
				If $asTimePart[1] = 0 Then $asTimePart[1] = 12
			Else
				$sTempTime = StringReplace($sTempTime, "tt", $sPM)
				If $asTimePart[1] > 12 Then $asTimePart[1] = $asTimePart[1] - 12
			EndIf
		EndIf
		$asTimePart[1] = StringRight("0" & $asTimePart[1], 2)
		$asTimePart[2] = StringRight("0" & $asTimePart[2], 2)
		$asTimePart[3] = StringRight("0" & $asTimePart[3], 2)
		$sTempTime = StringReplace($sTempTime, "hh", StringFormat( "%02d", $asTimePart[1]))
		$sTempTime = StringReplace($sTempTime, "h", StringReplace(StringLeft($asTimePart[1], 1), "0", "") & StringRight($asTimePart[1], 1))
		$sTempTime = StringReplace($sTempTime, "mm", StringFormat( "%02d", $asTimePart[2]))
		$sTempTime = StringReplace($sTempTime, "ss", StringFormat( "%02d", $asTimePart[3]))
		$sTempDate = StringStripWS($sTempDate & " " & $sTempTime, 3)
	EndIf
	Return ($sTempDate)
EndFunc   ;==>_DateTimeFormat
Func _DateDiff($sType, $sStartDate, $sEndDate)
	Local $asStartDatePart[4]
	Local $asStartTimePart[4]
	Local $asEndDatePart[4]
	Local $asEndTimePart[4]
	Local $iTimeDiff
	Local $iYearDiff
	Local $iMonthDiff
	Local $iStartTimeInSecs
	Local $iEndTimeInSecs
	Local $aDaysDiff
	$sType = StringLeft($sType, 1)
	If StringInStr("d,m,y,w,h,n,s", $sType) = 0 Or $sType = "" Then
		SetError(1)
		Return (0)
	EndIf
	If Not _DateIsValid($sStartDate) Then
		SetError(2)
		Return (0)
	EndIf
	If Not _DateIsValid($sEndDate) Then
		SetError(3)
		Return (0)
	EndIf
	_DateTimeSplit($sStartDate, $asStartDatePart, $asStartTimePart)
	_DateTimeSplit($sEndDate, $asEndDatePart, $asEndTimePart)
	$aDaysDiff = _DateToDayValue($asEndDatePart[1], $asEndDatePart[2], $asEndDatePart[3]) - _DateToDayValue($asStartDatePart[1], $asStartDatePart[2], $asStartDatePart[3])
	If $asStartTimePart[0] > 1 And $asEndTimePart[0] > 1 Then
		$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
		$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
		$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
		If $iTimeDiff < 0 Then
			$aDaysDiff = $aDaysDiff - 1
			$iTimeDiff = $iTimeDiff + 24 * 60 * 60
		EndIf
	Else
		$iTimeDiff = 0
	EndIf
	Select
		Case $sType = "d"
			Return ($aDaysDiff)
		Case $sType = "m"
			$iYearDiff = $asEndDatePart[1] - $asStartDatePart[1]
			$iMonthDiff = $asEndDatePart[2] - $asStartDatePart[2] + $iYearDiff * 12
			If $asEndDatePart[3] < $asStartDatePart[3]Then $iMonthDiff = $iMonthDiff - 1
			$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
			$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
			$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
			If $asEndDatePart[3] = $asStartDatePart[3]And $iTimeDiff < 0 Then $iMonthDiff = $iMonthDiff - 1
			Return ($iMonthDiff)
		Case $sType = "y"
			$iYearDiff = $asEndDatePart[1] - $asStartDatePart[1]
			If $asEndDatePart[2] < $asStartDatePart[2]Then $iYearDiff = $iYearDiff - 1
			If $asEndDatePart[2] = $asStartDatePart[2]And $asEndDatePart[3] < $asStartDatePart[3]Then $iYearDiff = $iYearDiff - 1
			$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
			$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
			$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
			If $asEndDatePart[2] = $asStartDatePart[2]And $asEndDatePart[3] = $asStartDatePart[3]And $iTimeDiff < 0 Then $iYearDiff = $iYearDiff - 1
			Return ($iYearDiff)
		Case $sType = "w"
			Return (Int($aDaysDiff / 7))
		Case $sType = "h"
			Return ($aDaysDiff * 24 + Int($iTimeDiff / 3600))
		Case $sType = "n"
			Return ($aDaysDiff * 24 * 60 + Int($iTimeDiff / 60))
		Case $sType = "s"
			Return ($aDaysDiff * 24 * 60 * 60 + $iTimeDiff)
	EndSelect
EndFunc   ;==>_DateDiff
Func _DateIsValid($sDate)
	Local $asDatePart[4]
	Local $asTimePart[4]
	Local $iNumDays
	$iNumDays = "31,28,31,30,31,30,31,31,30,31,30,31"
	$iNumDays = StringSplit($iNumDays, ",")
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)
	If $asDatePart[0] <> 3 Then
		Return (0)
	EndIf
	If _DateIsLeapYear($asDatePart[1]) Then $iNumDays[2] = 29
	If $asDatePart[1] < 1000 Or $asDatePart[1] > 2999 Then Return (0)
	If $asDatePart[2] < 1 Or $asDatePart[2] > 12 Then Return (0)
	If $asDatePart[3] < 1 Or $asDatePart[3] > $iNumDays[$asDatePart[2]]Then Return (0)
	If $asTimePart[0] < 1 Then Return (1)
	If $asTimePart[0] < 2 Then Return (0)
	If $asTimePart[1] < 0 Or $asTimePart[1] > 23 Then Return (0)
	If $asTimePart[2] < 0 Or $asTimePart[2] > 59 Then Return (0)
	If $asTimePart[3] < 0 Or $asTimePart[3] > 59 Then Return (0)
	Return (1)
EndFunc   ;==>_DateIsValid
Func _DateTimeSplit($sDate, ByRef $asDatePart, ByRef $iTimePart)
	Local $sDateTime
	Local $x
	$sDateTime = StringSplit($sDate, " T")
	If $sDateTime[0] > 0 Then $asDatePart = StringSplit($sDateTime[1], "/-.")
	If $sDateTime[0] > 1 Then
		$iTimePart = StringSplit($sDateTime[2], ":")
		If UBound($iTimePart) < 4 Then ReDim $iTimePart[4]
	Else
		Dim $iTimePart[4]
	EndIf
	If UBound($asDatePart) < 4 Then ReDim $asDatePart[4]
	For $x = 1 To 3
		$asDatePart[$x] = Number($asDatePart[$x])
		$iTimePart[$x] = Number($iTimePart[$x])
	Next
	Return (1)
EndFunc   ;==>_DateTimeSplit
Func _DateToDayOfWeek($iYear, $iMonth, $iDay)
	Local $i_aFactor
	Local $i_yFactor
	Local $i_mFactor
	Local $i_dFactor
	If Not _DateIsValid($iYear & "/" & $iMonth & "/" & $iDay) Then
		SetError(1)
		Return ("")
	EndIf
	$i_aFactor = Int((14 - $iMonth) / 12)
	$i_yFactor = $iYear - $i_aFactor
	$i_mFactor = $iMonth + (12 * $i_aFactor) - 2
	$i_dFactor = Mod($iDay + $i_yFactor + Int($i_yFactor / 4) - Int($i_yFactor / 100) + Int($i_yFactor / 400) + Int((31 * $i_mFactor) / 12), 7)
	return ($i_dFactor + 1)
EndFunc   ;==>_DateToDayOfWeek
Func _DateDayOfWeek($iDayNum, $iShort = 0)
	Local $aDayOfWeek[8]
	$aDayOfWeek[1] = "Sunday"
	$aDayOfWeek[2] = "Monday"
	$aDayOfWeek[3] = "Tuesday"
	$aDayOfWeek[4] = "Wednesday"
	$aDayOfWeek[5] = "Thursday"
	$aDayOfWeek[6] = "Friday"
	$aDayOfWeek[7] = "Saturday"
	Select
		Case Not StringIsInt($iDayNum) Or Not StringIsInt($iShort)
			SetError(1)
			Return ""
		Case $iDayNum < 1 Or $iDayNum > 7
			SetError(1)
			Return ""
		Case Else
			Select
				Case $iShort = 0
					Return $aDayOfWeek[$iDayNum]
				Case $iShort = 1
					Return StringLeft($aDayOfWeek[$iDayNum], 3)
				Case Else
					SetError(1)
					Return ""
			EndSelect
	EndSelect
EndFunc   ;==>_DateDayOfWeek
Func _DateMonthOfYear($iMonthNum, $iShort)
	Local $aMonthOfYear[13]
	$aMonthOfYear[1] = "January"
	$aMonthOfYear[2] = "February"
	$aMonthOfYear[3] = "March"
	$aMonthOfYear[4] = "April"
	$aMonthOfYear[5] = "May"
	$aMonthOfYear[6] = "June"
	$aMonthOfYear[7] = "July"
	$aMonthOfYear[8] = "August"
	$aMonthOfYear[9] = "September"
	$aMonthOfYear[10] = "October"
	$aMonthOfYear[11] = "November"
	$aMonthOfYear[12] = "December"
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iShort)
			SetError(1)
			Return ""
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return ""
		Case Else
			Select
				Case $iShort = 0
					Return $aMonthOfYear[$iMonthNum]
				Case $iShort = 1
					Return StringLeft($aMonthOfYear[$iMonthNum], 3)
				Case Else
					SetError(1)
					Return ""
			EndSelect
	EndSelect
EndFunc   ;==>_DateMonthOfYear
Func _DateToDayValue($iYear, $iMonth, $iDay)
	Local $i_aFactor
	Local $i_bFactor
	Local $i_cFactor
	Local $i_eFactor
	Local $i_fFactor
	Local $iJulianDate
	If Not _DateIsValid(StringFormat( "%04d/%02d/%02d", $iYear, $iMonth, $iDay)) Then
		SetError(1)
		Return ("")
	EndIf
	If $iMonth < 3 Then
		$iMonth = $iMonth + 12
		$iYear = $iYear - 1
	EndIf
	$i_aFactor = Int($iYear / 100)
	$i_bFactor = Int($i_aFactor / 4)
	$i_cFactor = 2 - $i_aFactor + $i_bFactor
	$i_eFactor = Int(1461 * ($iYear + 4716) / 4)
	$i_fFactor = Int(153 * ($iMonth + 1) / 5)
	$iJulianDate = $i_cFactor + $iDay + $i_eFactor + $i_fFactor - 1524.5
	return ($iJulianDate)
EndFunc   ;==>_DateToDayValue
Func _DateIsLeapYear($iYear)
	If StringIsInt($iYear) Then
		Select
			Case Mod($iYear, 4) = 0 And Mod($iYear, 100) <> 0
				Return 1
			Case Mod($iYear, 400) = 0
				Return 1
			Case Else
				Return 0
		EndSelect
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_DateIsLeapYear