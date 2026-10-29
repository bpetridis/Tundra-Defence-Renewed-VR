;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMapManage.psc
Modified : 2017-12-29 08:17:08
Compiled : 2017-12-29 08:17:10
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMapManage Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property Controls Auto
Message Property ControlsB Auto
Message Property CountReset Auto
Quest Property MainQuest Auto
Message Property Manager Auto
Quest Property PlayerQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActionRef)
  Int guardcount = (MainQuest as aaafortmainquestscript).guardcount ; #DEBUG_LINE_NO:11
  Int scavengercount = (MainQuest as aaafortmainquestscript).scavengercount ; #DEBUG_LINE_NO:12
  Int daycount = (MainQuest as aaafortmainquestscript).daycount ; #DEBUG_LINE_NO:13
  Int citizencount = (MainQuest as aaafortmainquestscript).citizencount ; #DEBUG_LINE_NO:14
  Int selection = Manager.Show(daycount as Float, guardcount as Float, scavengercount as Float, citizencount as Float, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:15
  If selection == 0 ; #DEBUG_LINE_NO:16
    (PlayerQuest as aaafortplayerquestscript).EndRaid() ; #DEBUG_LINE_NO:17
  ElseIf selection == 1 ; #DEBUG_LINE_NO:18
    Int result = Controls.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:19
    If result == 0 ; #DEBUG_LINE_NO:20
      ControlsB.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:21
    EndIf
  ElseIf selection == 2 ; #DEBUG_LINE_NO:23
    Int result = CountReset.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:24
    If result == 0 ; #DEBUG_LINE_NO:25
      (MainQuest as aaafortmainquestscript).guardcount = 0 ; #DEBUG_LINE_NO:26
    ElseIf result == 1 ; #DEBUG_LINE_NO:27
      (MainQuest as aaafortmainquestscript).scavengercount = 0 ; #DEBUG_LINE_NO:28
    ElseIf result == 2 ; #DEBUG_LINE_NO:29
      (MainQuest as aaafortmainquestscript).citizencount = 0 ; #DEBUG_LINE_NO:30
    EndIf
  EndIf
EndEvent
