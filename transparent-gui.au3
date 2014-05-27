#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Global $trans = 0
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 441, 211, 192, 124)
$Button1 = GUICtrlCreateButton("Transparents ändern", 56, 40, 337, 129, $WS_GROUP)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
                Case $GUI_EVENT_CLOSE
                        Exit

                Case $Button1
                        If $trans = 0 Then
                                $trans = 1
                                WinSetTrans($Form1, "", 230)
                        Else
                                $trans = 0
                                WinSetTrans($Form1, "", 255)
                        EndIf
        EndSwitch
WEnd