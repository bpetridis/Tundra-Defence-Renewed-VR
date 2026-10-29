;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMinerScript.psc
Modified : 2012-09-08 12:52:19
Compiled : 2017-12-29 05:45:00
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMinerScript Extends Actor

;-- Variables ---------------------------------------

; Set when the corpse is waiting out its removal delay. See OnDeath.
Bool pendingDelete

;-- Properties --------------------------------------
Quest Property MainQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

; Was Utility.Wait(30) followed by Delete(). A held Wait keeps this script's stack suspended for
; the whole 30 seconds; a timer releases it immediately and schedules the callback instead. Same
; delay, nothing held.
Event OnDeath(Actor akKiller)
  (MainQuest as aaafortmainquestscript).MinerCount = (MainQuest as aaafortmainquestscript).MinerCount - 1 ; #DEBUG_LINE_NO:6
  pendingDelete = True
  Self.UnregisterForUpdate()
  Self.RegisterForSingleUpdate(30 as Float) ; #DEBUG_LINE_NO:7
EndEvent

Event OnUpdate()
  If pendingDelete
    pendingDelete = False
    Self.Delete() ; #DEBUG_LINE_NO:8
  EndIf
EndEvent
