;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMultiDoorTeleport.psc
Modified : 2012-09-16 19:25:36
Compiled : 2017-12-29 05:45:02
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMultiDoorTeleport Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ObjectReference Property FromMarker Auto
Bool Property Interior = False Auto
ObjectReference Property Target Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnLoad()
  If Interior == False ; #DEBUG_LINE_NO:8
    FromMarker.MoveTo(Game.GetPlayer() as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:9
  EndIf
EndEvent

Event OnActivate(ObjectReference akActionRef)
  If !Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:14
    If Interior ; #DEBUG_LINE_NO:15
      akActionRef.MoveTo(Target, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:16
    Else
      FromMarker.MoveTo(akActionRef, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:18
      FromMarker.SetAngle(0.0, 0.0, 180.0) ; #DEBUG_LINE_NO:19
      akActionRef.MoveTo(Target, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:20
    EndIf
  EndIf
EndEvent
