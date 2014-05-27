;===========================================;
;  Creado por Jesux Herrera (Author)
;  www.autoithacks.tk
;  http://www.facebook.com/pages/AutoIt-Hacks-Mexico/211931559655
;  https://twitter.com/#!/AutoitHacks
;  http://www.youtube.com/user/autoithacks
;  autoit-hacks@msn.com
;  " a ti mi amada Maricela "
;===========================================;

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>

Ejemplo()


 Func Ejemplo()

         $Form = GUICreate("Barra de Progreso - Ejemplo", 333, 141, -1, -1)
         $Group1 = GUICtrlCreateGroup("", 8, 8, 313, 121)
         $Progress1 = GUICtrlCreateProgress(24, 32, 278, 24)
         $ejemplo1 = GUICtrlCreateButton("Ejemplo1", 40, 80, 75, 25)
         $ejemplo2 = GUICtrlCreateButton("Ejemplo2", 128, 80, 75, 25)
         $creditos = GUICtrlCreateButton("Creditos", 216, 80, 75, 25)
         GUICtrlCreateGroup("", -99, -99, 1, 1)
         GUISetState(@SW_SHOW)

     Local $inicio = 0
         Local $final = 100
         Local $espera = 10

        While 1
              $nMsg = GUIGetMsg()
              Switch $nMsg
                    Case $GUI_EVENT_CLOSE
                          Exit

                         Case $ejemplo1
                                         Do
                                                 GUICtrlSetData($Progress1, $inicio)
                                                 $inicio = $inicio + 1
                                                 Sleep($espera)
                                         Until $inicio = 100
                                         GUICtrlSetData($Progress1,0)

                         Case $ejemplo2
                                         Do
                                                 GUICtrlSetData($Progress1, $final)
                                                 $final = $final - 1
                                                 Sleep($espera)
                                         Until $final = 0
                                         GUICtrlSetData($Progress1,0)

                         Case $creditos
                                         MsgBox(0,"AutoitHacks :D","Creado por Jesux Herrera - AutoitHacks Admin" & @CRLF & @CRLF & "Pagina: www.autoithacks.tk" & @CRLF & "Pastebin: http://pastebin.com/u/autoithacks" & @CRLF & "Facebook: http://www.facebook.com/pages/AutoIt-Hacks-Mexico/211931559655" & @CRLF & "Twitter: https://twitter.com/#!/AutoitHacks" & @CRLF & "Youtube: http://www.youtube.com/user/autoithacks" & @CRLF & "Mail: autoit-hacks@msn.com" & @CRLF & @CRLF & "Maricela </3  u.u")

             EndSwitch
             WEnd

 EndFunc