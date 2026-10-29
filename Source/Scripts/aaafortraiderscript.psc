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

; Which removal is pending: 0 none, 1 delete only, 2 salvage to the scavenger crate then delete.
; Both paths used to hold a Utility.Wait open across the delay; they now arm a timer instead.
Int pendingDelete

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
      ; The items have already moved, so this is a plain delayed delete.
      pendingDelete = 1
      Self.UnregisterForUpdate()
      Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:10
    EndIf
  EndIf
EndEvent

; This was the most costly Wait in the mod. Every raider that died held a suspended script stack
; for two full minutes before deleting itself, and a raid kills many of them at once, so the held
; stacks piled up and overlapped exactly when the engine was busiest. A timer costs nothing while
; it waits.
;
; The scavenger salvage below deliberately stays on the delayed side rather than moving up here:
; the original read ScavengerCount and ScavengerCrateRef AFTER the wait, so a scavenger hired
; during those two minutes still collects from this corpse. Checking it now would change that.
Event OnDeath(Actor akKiller)
  If (PlayerQuest as aaafortplayerquestscript).isRaid ; #DEBUG_LINE_NO:18
    (PlayerQuest as aaafortplayerquestscript).CurrentRaiders = (PlayerQuest as aaafortplayerquestscript).CurrentRaiders - 1 ; #DEBUG_LINE_NO:19
  EndIf
  pendingDelete = 2
  Self.UnregisterForUpdate()
  Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:21
EndEvent

Event OnUpdate()
  If pendingDelete == 2
    Quest MainQuest = (PlayerQuest as aaafortplayerquestscript).MainQuest ; #DEBUG_LINE_NO:17
    If (MainQuest as aaafortmainquestscript).ScavengerCount > 0 ; #DEBUG_LINE_NO:22
      If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:23
        Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:24
      EndIf
    EndIf
  EndIf
  If pendingDelete != 0
    pendingDelete = 0
    Self.Delete() ; #DEBUG_LINE_NO:27
  EndIf
EndEvent
