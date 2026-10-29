;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortDeleteAfterUse.psc
Modified : 2012-08-30 17:02:55
Compiled : 2017-12-29 05:44:39
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortDeleteAfterUse Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Bool Property used = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If Game.GetPlayer() as ObjectReference == akActivator ; #DEBUG_LINE_NO:6
    used = True ; #DEBUG_LINE_NO:7
  EndIf
EndEvent

Event OnUnload()
  If used ; #DEBUG_LINE_NO:12
    Self.Delete() ; #DEBUG_LINE_NO:13
  EndIf
EndEvent
