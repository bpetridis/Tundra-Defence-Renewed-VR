;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortAddPlanScript.psc
Modified : 2012-09-16 19:41:14
Compiled : 2017-12-29 05:44:30
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortAddPlanScript Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property Plan Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  akCaster.AddItem(Plan as Form, 1, False) ; #DEBUG_LINE_NO:6
EndEvent
