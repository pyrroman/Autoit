#cs ----------------------------------------------------------------------------

   ;Autor: enzo_
   ;Linguagem: AutoIt
   ;Função: Drag and Drop

#ce ----------------------------------------------------------------------------

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Func Drag File and Drop", 256, 53, -1, -1,-1, $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_DROPPED, "Drag")
$Input1 = GUICtrlCreateInput("[ ... ]", 8, 24, 241, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Label1 = GUICtrlCreateLabel("Arraste o arquivo e solte", 8, 8, 118, 16)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Func Drag()
   ConsoleWrite("ID: "&@GUI_DRAGID & " File: "&@GUI_DRAGFILE &" Drop: "&@GUI_DROPID&@CRLF)
EndFunc

While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
                Case $GUI_EVENT_CLOSE
                        Exit

        EndSwitch
WEnd