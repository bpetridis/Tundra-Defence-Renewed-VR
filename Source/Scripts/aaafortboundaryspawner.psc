;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortBoundarySpawner.psc
Modified : 2017-12-31 06:06:31
Compiled : 2017-12-31 06:06:32
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortBoundarySpawner Extends ActiveMagicEffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property Cancel Auto
Bool Property IsMarket Auto
Quest Property MainQuest Auto
ObjectReference Property SpawnRef Auto
ObjectReference Property collisionRef Auto
Bool Property instantReuse = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If (MainQuest as aaafortmainquestscript).stage != 1 ; #DEBUG_LINE_NO:11
    SpawnRef.MoveTo(Game.GetPlayer() as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:12
    SpawnRef.Enable(False) ; #DEBUG_LINE_NO:13
    If IsMarket ; #DEBUG_LINE_NO:14
      (MainQuest as aaafortmainquestscript).setMarket = True ; #DEBUG_LINE_NO:15
    EndIf
    If !(MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:17
      instantReuse = False ; #DEBUG_LINE_NO:18
    EndIf
    If collisionRef != None ; #DEBUG_LINE_NO:20
      (MainQuest as aaafortmainquestscript).collisionRef = collisionRef ; #DEBUG_LINE_NO:21
    Else
      (MainQuest as aaafortmainquestscript).collisionRef = None ; #DEBUG_LINE_NO:23
    EndIf
    (MainQuest as aaafortmainquestscript).StartPositioning(SpawnRef, Cancel, instantReuse, True) ; #DEBUG_LINE_NO:25
  Else
    Debug.Notification("You are already in object placement mode!") ; #DEBUG_LINE_NO:27
    Game.GetPlayer().AddItem(Cancel as Form, 1, False) ; #DEBUG_LINE_NO:28
  EndIf
EndEvent
