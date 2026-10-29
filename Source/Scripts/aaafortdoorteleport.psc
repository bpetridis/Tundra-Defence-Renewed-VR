;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortDoorTeleport.psc
Modified : 2012-10-09 18:28:53
Compiled : 2017-12-29 05:44:42
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortDoorTeleport Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ObjectReference Property FromMarker Auto
Bool Property Interior = False Auto
ObjectReference Property Target Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActionRef)
  If !Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:8
    If Interior ; #DEBUG_LINE_NO:9
      akActionRef.MoveTo(Target, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:10
    Else
      FromMarker.MoveTo(akActionRef, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:12
      FromMarker.SetAngle(0.0, 0.0, 180.0) ; #DEBUG_LINE_NO:13
      akActionRef.MoveTo(Target, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:14
    EndIf
  EndIf
EndEvent
