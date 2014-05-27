Global $nCheck

GuiCreate("Timer",200,50)
$hLabel = GuiCtrlCreateLabel("", 10, 10, 180, 20)
GuiSetState()

While 1
    time()
    If GUIGetMsg() = -3 Then Exit
WEnd

Func time()
    If @SEC <> $nCheck Then
        GUICtrlSetData($hLabel, "The current time is " & @HOUR & ":" & @MIN & ":" & @SEC & ".")
        $nCheck = @SEC
    EndIf
EndFunc