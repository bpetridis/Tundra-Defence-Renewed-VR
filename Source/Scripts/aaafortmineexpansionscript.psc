;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMineExpansionScript.psc
Modified : 2012-09-08 12:41:05
Compiled : 2017-12-29 05:44:58
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMineExpansionScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property Dialog Auto
MiscObject Property Gold001 Auto
Message Property NotEnoughGold Auto
Int Property cost = 2000 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If akActivator == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:9
    Int result = Dialog.Show(cost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:10
    If result == 0 ; #DEBUG_LINE_NO:11
      If Game.GetPlayer().GetItemCount(Gold001 as Form) >= cost ; #DEBUG_LINE_NO:12
        Game.GetPlayer().RemoveItem(Gold001 as Form, cost, False, None) ; #DEBUG_LINE_NO:13
        Self.Delete() ; #DEBUG_LINE_NO:14
      Else
        NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:16
      EndIf
    EndIf
  EndIf
EndEvent
