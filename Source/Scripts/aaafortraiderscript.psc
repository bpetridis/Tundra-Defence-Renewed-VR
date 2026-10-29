;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortRaiderScript.psc
Modified : 2012-09-30 04:11:31
Compiled : 2017-12-29 05:45:12
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortRaiderScript Extends Actor

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Quest Property PlayerQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  Quest MainQuest = (PlayerQuest as aaafortplayerquestscript).MainQuest ; #DEBUG_LINE_NO:6
  If Self.IsDead() && (MainQuest as aaafortmainquestscript).ScavengerCount > 0 && (akActivator != Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:7
    If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:8
      Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:9
      Utility.Wait(5 as Float) ; #DEBUG_LINE_NO:10
      Self.Delete() ; #DEBUG_LINE_NO:11
    EndIf
  EndIf
EndEvent

Event OnDeath(Actor akKiller)
  Quest MainQuest = (PlayerQuest as aaafortplayerquestscript).MainQuest ; #DEBUG_LINE_NO:17
  If (PlayerQuest as aaafortplayerquestscript).isRaid ; #DEBUG_LINE_NO:18
    (PlayerQuest as aaafortplayerquestscript).CurrentRaiders = (PlayerQuest as aaafortplayerquestscript).CurrentRaiders - 1 ; #DEBUG_LINE_NO:19
  EndIf
  Utility.Wait(120 as Float) ; #DEBUG_LINE_NO:21
  If (MainQuest as aaafortmainquestscript).ScavengerCount > 0 ; #DEBUG_LINE_NO:22
    If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:23
      Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:24
    EndIf
  EndIf
  Self.Delete() ; #DEBUG_LINE_NO:27
EndEvent
