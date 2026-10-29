;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortLookoutScript.psc
Modified : 2012-08-24 16:56:35
Compiled : 2017-12-29 05:44:54
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortLookoutScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property LookoutDialog Auto
Quest Property MainQuest Auto
Quest Property PlayerQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivatingObject)
  LookoutDialog.Show((MainQuest as aaafortmainquestscript).GuardCount as Float, (MainQuest as aaafortmainquestscript).ScavengerCount as Float, (MainQuest as aaafortmainquestscript).CitizenCount as Float, (PlayerQuest as aaafortplayerquestscript).CurrentRaiders as Float, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:8
EndEvent
