;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortPlayerHouseButtonScript.psc
Modified : 2017-12-31 06:34:20
Compiled : 2017-12-31 06:34:21
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortPlayerHouseButtonScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property DistortDialog Auto
ObjectReference Property Reveal Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  DistortDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:7
  If Reveal.IsDisabled() ; #DEBUG_LINE_NO:8
    Reveal.Enable(False) ; #DEBUG_LINE_NO:9
  Else
    Reveal.Disable(False) ; #DEBUG_LINE_NO:11
  EndIf
EndEvent
