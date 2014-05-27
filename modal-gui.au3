#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)

$hWnd_1 = GUICreate("Test", 400, 400)
$cButton = GUICtrlCreateButton("2nd GUI", 50, 50, 60, 25)
GUISetState()

$hWnd_2 = GUICreate("Test 2", 300, 300, Default, Default, Default, Default, $hWnd_1)

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit", $hWnd_1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_CloseGUI2", $hWnd_2)
GUICtrlSetOnEvent($cButton, "_OpenGUI2")

While Sleep(1000)
WEnd

Func _Exit()
        Exit
EndFunc

Func _OpenGUI2()
        GUISetState(@SW_SHOW, $hWnd_2)
        GUISetState(@SW_DISABLE, $hWnd_1)
EndFunc

Func _CloseGUI2()
        GUISetState(@SW_HIDE, $hWnd_2)
        GUISetState(@SW_ENABLE, $hWnd_1)
        WinActivate($hWnd_1)
EndFunc