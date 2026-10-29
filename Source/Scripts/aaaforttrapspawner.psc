;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortTrapSpawner.psc
Modified : 2012-08-22 15:39:39
Compiled : 2017-12-29 05:45:19
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortTrapSpawner Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Activator Property Trap Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Game.GetPlayer().PlaceAtMe(Trap as Form, 1, False, False) ; #DEBUG_LINE_NO:6
  Debug.Notification("A trap has been placed at your feet.") ; #DEBUG_LINE_NO:7
EndEvent
