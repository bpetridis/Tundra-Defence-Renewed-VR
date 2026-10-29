;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortTravelingMerchantScript.psc
Modified : 2012-10-06 18:57:20
Compiled : 2017-12-29 05:45:20
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortTravelingMerchantScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Int Property currentDay = 0 Auto
Int Property startDate = 0 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

; The merchant packs up after two game days. This used to be done by waking every 120 seconds of
; real time and asking whether the game day had changed - so roughly 1,440 wake-ups to notice two
; events. Papyrus has a game-time timer for exactly this: one tick per game day, same outcome.
Event OnInit()
  currentDay = Utility.GetCurrentGameTime() as Int ; #DEBUG_LINE_NO:7
  startDate = 0 ; #DEBUG_LINE_NO:8
  Self.RegisterForSingleUpdateGameTime(24.0)
EndEvent

Event OnUpdateGameTime()
  currentDay = Utility.GetCurrentGameTime() as Int ; #DEBUG_LINE_NO:14
  startDate += 1 ; #DEBUG_LINE_NO:15
  If startDate > 1 ; #DEBUG_LINE_NO:16
    Self.Delete() ; #DEBUG_LINE_NO:17
    Return
  EndIf
  Self.RegisterForSingleUpdateGameTime(24.0)
EndEvent
