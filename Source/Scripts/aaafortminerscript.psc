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

;-- Properties --------------------------------------
Quest Property MainQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnDeath(Actor akKiller)
  (MainQuest as aaafortmainquestscript).MinerCount = (MainQuest as aaafortmainquestscript).MinerCount - 1 ; #DEBUG_LINE_NO:6
  Utility.Wait(30 as Float) ; #DEBUG_LINE_NO:7
  Self.Delete() ; #DEBUG_LINE_NO:8
EndEvent
