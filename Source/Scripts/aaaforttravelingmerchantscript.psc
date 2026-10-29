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

Event OnInit()
  currentDay = Utility.GetCurrentGameTime() as Int ; #DEBUG_LINE_NO:7
  startDate = 0 ; #DEBUG_LINE_NO:8
  Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:9
EndEvent

Event OnUpdate()
  If Utility.GetCurrentGameTime() as Int != currentDay ; #DEBUG_LINE_NO:13
    currentDay = Utility.GetCurrentGameTime() as Int ; #DEBUG_LINE_NO:14
    startDate += 1 ; #DEBUG_LINE_NO:15
    If startDate > 1 ; #DEBUG_LINE_NO:16
      Self.Delete() ; #DEBUG_LINE_NO:17
    EndIf
  EndIf
  Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:20
EndEvent
