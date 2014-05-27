Func _GUICtrlCreateTab($iHWnd = '', $iLeft = 0, $iTop = 0, $iWidth = 100, $iHeight = 100, $iStyle = -1, $iExStyle = Default)
	If IsHWnd($iHWnd) Then
		Global $GUICtrlCreateTabArray[3]
		$GUICtrlCreateTabArray[2] = $iHWnd
		$GUICtrlCreateTabArray[1] = GUICreate("", $iWidth, $iHeight, $iLeft, $iTop, 0x40000000, Default, $iHWnd)
		$GUICtrlCreateTabArray[0] = GUICtrlCreateTab(0, 0, $iWidth, $iHeight, $iStyle, $iExStyle)
		$nExStyle = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", $GUICtrlCreateTabArray[1], "int", 0xEC)
		DllCall("user32.dll", "int", "SetWindowLong", "hwnd", $GUICtrlCreateTabArray[1], "int", 0xEC, "int", BitOR($nExStyle[0], 0x00000040))
		DllCall("user32.dll", "int", "SetParent", "hwnd", $GUICtrlCreateTabArray[1], "hwnd", $iHWnd)
		GUISetState(@SW_SHOW, $GUICtrlCreateTabArray[1])
		Return $GUICtrlCreateTabArray
	ElseIf IsNumber($iHWnd) Then
		GUICtrlSetState($iHWnd, 16)
		GUISwitch($GUICtrlCreateTabArray[2])
		Return
	EndIf
EndFunc   ;==>_GUICtrlCreateTab

Func _GUICtrlCreateTabSetState($Flag, $i_HWnd)
		Return GUISetState($Flag, $i_HWnd[1])
EndFunc   ;==>_GUICtrlCreateTabSetState

Func _GUICtrlCreateTabGetId($iObjects)
	Return $iObjects[0]
EndFunc   ;==>_GUICtrlCreateTabGetId