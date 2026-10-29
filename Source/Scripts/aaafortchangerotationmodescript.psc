;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortChangeRotationModeScript.psc
Modified : 2017-12-29 19:42:39
Compiled : 2017-12-29 19:42:41
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortChangeRotationModeScript Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property ChangeRotation Auto
aaafortmainquestscript Property MainQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  MainQuest.ChangeRotationAxis() ; #DEBUG_LINE_NO:7
  If Game.GetPlayer().GetItemCount(ChangeRotation as Form) == 0 ; #DEBUG_LINE_NO:8
    Game.GetPlayer().AddItem(ChangeRotation as Form, 1, False) ; #DEBUG_LINE_NO:9
  EndIf
EndEvent
