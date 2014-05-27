#include <GUIConstants.au3>
#include <SendMessage.au3>

$hWnd = GUICreate("LIstView Button Navigation", 300, 410)
$cList = GUICtrlCreateListView("Test A|TestB", 5, 5, 290, 340)
$cButton_Up = GUICtrlCreateButton("Up", 5, 350, 80, 25)
$cButton_Down = GUICtrlCreateButton("Down", 5, 380, 80, 25)
GUISetState()

$hWnd_ListView = GUICtrlGetHandle($cList)

For $i = 1 To 20
        GUICtrlCreateListViewItem($i & "|" & Random(), $cList)
Next

While True
        Switch GUIGetMsg()
                Case $GUI_EVENT_CLOSE
                        Exit
                Case $cButton_Up
                        _SendMessage($hWnd_ListView, $WM_KEYDOWN, 0x26, 0)
                        Sleep(100)
                        _SendMessage($hWnd_ListView, $WM_KEYUP, 0x26, 0)
                        ControlFocus($hWnd, "", $cList)
                Case $cButton_Down
                        _SendMessage($hWnd_ListView, $WM_KEYDOWN, 0x28, 0)
                        Sleep(100)
                        _SendMessage($hWnd_ListView, $WM_KEYUP, 0x28, 0)
                        ControlFocus($hWnd, "", $cList)
        EndSwitch
WEnd