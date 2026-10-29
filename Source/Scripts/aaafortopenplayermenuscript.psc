;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortOpenPlayerMenuScript.psc
Modified : 2017-12-29 08:23:01
Compiled : 2017-12-29 08:24:12
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortOpenPlayerMenuScript Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property OutpostMenu Auto
Quest Property PlayerQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  (PlayerQuest as aaafortplayerquestscript).ShowDialog() ; #DEBUG_LINE_NO:7
  If Game.GetPlayer().GetItemCount(OutpostMenu as Form) == 0 ; #DEBUG_LINE_NO:8
    Game.GetPlayer().AddItem(OutpostMenu as Form, 1, False) ; #DEBUG_LINE_NO:9
  EndIf
EndEvent
