;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortObjectCloningQuestScript.psc
Modified : 2012-09-11 17:12:36
Compiled : 2017-12-29 05:45:06
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortObjectCloningQuestScript Extends Quest

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ReferenceAlias Property ClosestObject1 Auto
ReferenceAlias Property ClosestObject2 Auto
ReferenceAlias Property ClosestObject3 Auto
ReferenceAlias Property ClosestObject4 Auto
ReferenceAlias Property ClosestObject5 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:10
EndEvent

Event OnUpdate()
  Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:15
EndEvent
