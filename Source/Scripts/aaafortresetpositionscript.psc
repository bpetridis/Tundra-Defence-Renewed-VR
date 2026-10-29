;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortResetPositionScript.psc
Modified : 2017-12-31 09:57:08
Compiled : 2017-12-31 09:57:10
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortResetPositionScript Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
aaafortmainquestscript Property MainQuest Auto
Potion Property ResetPosition Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  MainQuest.ResetObjectPosition() ; #DEBUG_LINE_NO:7
  If Game.GetPlayer().GetItemCount(ResetPosition as Form) == 0 ; #DEBUG_LINE_NO:8
    Game.GetPlayer().AddItem(ResetPosition as Form, 1, False) ; #DEBUG_LINE_NO:9
  EndIf
EndEvent
