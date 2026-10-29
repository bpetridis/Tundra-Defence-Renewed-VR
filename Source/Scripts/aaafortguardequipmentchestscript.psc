;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortGuardEquipmentChestScript.psc
Modified : 2012-10-29 17:41:38
Compiled : 2017-12-29 05:44:48
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortGuardEquipmentChestScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property Dialog Auto
Quest Property MainQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If (akActivator == Game.GetPlayer() as ObjectReference) && !Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:7
    Self.ChestMenu() ; #DEBUG_LINE_NO:8
  EndIf
EndEvent

Function ChestMenu()
  Int result = Dialog.Show(((MainQuest as aaafortmainquestscript).equipBoxEnabled as Int) as Float, ((MainQuest as aaafortmainquestscript).disperseDaily as Int) as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:13
  If result == 0 ; #DEBUG_LINE_NO:14
    (MainQuest as aaafortmainquestscript).equipBoxEnabled = !(MainQuest as aaafortmainquestscript).equipBoxEnabled ; #DEBUG_LINE_NO:15
    Self.ChestMenu() ; #DEBUG_LINE_NO:16
  ElseIf result == 1 ; #DEBUG_LINE_NO:17
    (MainQuest as aaafortmainquestscript).disperseDaily = !(MainQuest as aaafortmainquestscript).disperseDaily ; #DEBUG_LINE_NO:18
    Self.ChestMenu() ; #DEBUG_LINE_NO:19
  EndIf
EndFunction
