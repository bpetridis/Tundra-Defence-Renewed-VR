;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortObjectCloningResetterScript.psc
Modified : 2012-09-11 16:48:09
Compiled : 2017-12-29 05:45:07
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortObjectCloningResetterScript Extends Quest

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Weapon Property aaaFortObjectCloner Auto
Quest Property aaaFortObjectCloningQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:7
EndEvent

Event OnUpdate()
  If Game.GetPlayer().GetEquippedWeapon(False) == aaaFortObjectCloner ; #DEBUG_LINE_NO:11
    aaaFortObjectCloningQuest.Stop() ; #DEBUG_LINE_NO:12
    aaaFortObjectCloningQuest.Start() ; #DEBUG_LINE_NO:13
  EndIf
  Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:15
EndEvent
