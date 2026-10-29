;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortObjectSpawnerScript.psc
Modified : 2017-12-29 10:41:43
Compiled : 2017-12-29 10:42:04
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortObjectSpawnerScript Extends ActiveMagicEffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ActorBase Property ActorOnPlace Auto
Potion Property Cancel Auto
Quest Property MainQuest Auto
Container Property SpawnContainerRef Auto
Door Property SpawnDoorRef Auto
Furniture Property SpawnFurnitureRef Auto
Activator Property SpawnRef Auto
ObjectReference Property collisionRef Auto
Int Property distanceOnSpawn = 0 Auto
Bool Property instantReuse = False Auto
Bool Property isArcane = False Auto
Bool Property isMedic = False Auto
Int Property rotateOnSpawn = 0 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If (MainQuest as aaafortmainquestscript).stage != 1 ; #DEBUG_LINE_NO:18
    ObjectReference Ref
    If SpawnDoorRef != None ; #DEBUG_LINE_NO:20
      Ref = Game.GetPlayer().PlaceAtMe(SpawnDoorRef as Form, 1, False, False) ; #DEBUG_LINE_NO:21
    ElseIf SpawnFurnitureRef != None ; #DEBUG_LINE_NO:22
      Ref = Game.GetPlayer().PlaceAtMe(SpawnFurnitureRef as Form, 1, False, False) ; #DEBUG_LINE_NO:23
    ElseIf SpawnContainerRef != None ; #DEBUG_LINE_NO:24
      Ref = Game.GetPlayer().PlaceAtMe(SpawnContainerRef as Form, 1, False, False) ; #DEBUG_LINE_NO:25
    Else
      Ref = Game.GetPlayer().PlaceAtMe(SpawnRef as Form, 1, False, False) ; #DEBUG_LINE_NO:27
    EndIf
    If ActorOnPlace != None ; #DEBUG_LINE_NO:29
      (MainQuest as aaafortmainquestscript).ActorOnPlace = ActorOnPlace ; #DEBUG_LINE_NO:30
    Else
      (MainQuest as aaafortmainquestscript).ActorOnPlace = None ; #DEBUG_LINE_NO:32
    EndIf
    If isArcane ; #DEBUG_LINE_NO:34
      (MainQuest as aaafortmainquestscript).setArcane = True ; #DEBUG_LINE_NO:35
    ElseIf isMedic
      (MainQuest as aaafortmainquestscript).setMedic = True ; #DEBUG_LINE_NO:37
    EndIf
    If rotateOnSpawn != 0 ; #DEBUG_LINE_NO:39
      (MainQuest as aaafortmainquestscript).rotationz = rotateOnSpawn ; #DEBUG_LINE_NO:40
    EndIf
    If distanceOnSpawn != 0 ; #DEBUG_LINE_NO:42
      (MainQuest as aaafortmainquestscript).distance = distanceOnSpawn ; #DEBUG_LINE_NO:43
    EndIf
    If collisionRef != None ; #DEBUG_LINE_NO:46
      (MainQuest as aaafortmainquestscript).collisionRef = collisionRef ; #DEBUG_LINE_NO:47
    Else
      (MainQuest as aaafortmainquestscript).collisionRef = None ; #DEBUG_LINE_NO:49
    EndIf
    (MainQuest as aaafortmainquestscript).StartPositioning(Ref, Cancel, instantReuse, False) ; #DEBUG_LINE_NO:52
  Else
    Debug.Notification("You are already in object placement mode!") ; #DEBUG_LINE_NO:54
    Game.GetPlayer().AddItem(Cancel as Form, 1, False) ; #DEBUG_LINE_NO:55
  EndIf
EndEvent
