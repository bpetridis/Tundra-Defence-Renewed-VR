;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortKeyRebinderScript.psc
Modified : 2012-09-11 15:26:28
Compiled : 2017-12-29 05:44:53
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortKeyRebinderScript Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Quest Property PlayerQuest Auto
Potion Property Rebinder Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  (PlayerQuest as aaafortplayerquestscript).RebindDialog() ; #DEBUG_LINE_NO:7
  If Game.GetPlayer().GetItemCount(Rebinder as Form) == 0 ; #DEBUG_LINE_NO:8
    Game.GetPlayer().AddItem(Rebinder as Form, 1, False) ; #DEBUG_LINE_NO:9
  EndIf
EndEvent
