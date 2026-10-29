;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMultiObjectSpawner.psc
Modified : 2017-12-31 06:06:21
Compiled : 2017-12-31 06:06:22
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMultiObjectSpawner Extends ActiveMagicEffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property Cancel Auto
Quest Property MainQuest Auto
Activator[] Property SpawnRef Auto
Bool Property instantReuse = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If (MainQuest as aaafortmainquestscript).stage != 1 ; #DEBUG_LINE_NO:9
    Activator Spawn = SpawnRef[Utility.RandomInt(0, SpawnRef.Length - 1)] ; #DEBUG_LINE_NO:10
    ObjectReference Ref = Game.GetPlayer().PlaceAtMe(Spawn as Form, 1, False, False) ; #DEBUG_LINE_NO:11
    (MainQuest as aaafortmainquestscript).StartPositioning(Ref, Cancel, instantReuse, False) ; #DEBUG_LINE_NO:12
  Else
    Debug.Notification("You are already in object placement mode!") ; #DEBUG_LINE_NO:14
    Game.GetPlayer().AddItem(Cancel as Form, 1, False) ; #DEBUG_LINE_NO:15
  EndIf
EndEvent
