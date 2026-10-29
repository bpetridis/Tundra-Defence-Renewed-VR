;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortBreakdownScript.psc
Modified : 2012-09-13 17:06:05
Compiled : 2017-12-29 05:44:35
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortBreakdownScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property BreakdownDialog Auto
Potion Property Plan Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If Game.GetPlayer().IsSneaking() && (akActivator == Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:7
    Int result = BreakdownDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:8
    If result == 0 ; #DEBUG_LINE_NO:9
      Self.Delete() ; #DEBUG_LINE_NO:10
      Game.GetPlayer().AddItem(Plan as Form, 1, False) ; #DEBUG_LINE_NO:11
    EndIf
  EndIf
EndEvent
