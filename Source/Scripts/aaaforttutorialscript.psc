;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortTutorialScript.psc
Modified : 2017-12-31 09:58:30
Compiled : 2017-12-31 09:58:32
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortTutorialScript Extends Quest

;-- Variables ---------------------------------------
Bool guardDialog = False
Bool hasBoundaries = False

;-- Properties --------------------------------------
Message Property BarracksMessage Auto
Potion Property BarracksPlan Auto
Potion Property BoundaryMarkerAPlan Auto
Potion Property BoundaryMarkerBPlan Auto
Potion Property BoundaryMarkerCPlan Auto
Potion Property BoundaryMarkerDPlan Auto
Message Property BoundaryMessage Auto
Potion Property ChangeRotationPotion Auto
Message Property DoorMessage Auto
Message Property FirstGuardDialog Auto
Message Property HouseMessage Auto
WordOfPower Property InputConfirmWord Auto
Spell Property InputMinusSpell Auto
Spell Property InputPlusSpell Auto
Message Property IntroMessage Auto
Quest Property MainQuest Auto
Message Property MarketMessage Auto
Potion Property MarketPlan Auto
Potion Property OutpostMenuItem Auto
Potion Property PlayerHouseDoorPlan Auto
Potion Property PlayerHousePlan Auto
Message Property PlayerMenuMessage Auto
Quest Property PlayerQuest Auto
Quest Property RandomQuest Auto
Potion Property ResetPositionPotion Auto
Message Property TutorialComplete Auto
Quest Property TutorialQuest Auto
Potion Property WaterWellPlan Auto
Bool Property firstRaid = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Utility.Wait(5 as Float) ; #DEBUG_LINE_NO:39
  TutorialQuest.SetStage(10) ; #DEBUG_LINE_NO:40
  Game.GetPlayer().AddItem(WaterWellPlan as Form, 1, False) ; #DEBUG_LINE_NO:41
  Game.GetPlayer().AddItem(ChangeRotationPotion as Form, 1, False) ; #DEBUG_LINE_NO:42
  Game.GetPlayer().AddItem(ResetPositionPotion as Form, 1, False) ; #DEBUG_LINE_NO:43
  Game.GetPlayer().AddSpell(InputPlusSpell, True) ; #DEBUG_LINE_NO:44
  Game.GetPlayer().AddSpell(InputMinusSpell, True) ; #DEBUG_LINE_NO:45
  Game.TeachWord(InputConfirmWord) ; #DEBUG_LINE_NO:46
  Game.UnlockWord(InputConfirmWord) ; #DEBUG_LINE_NO:47
  IntroMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:48
  (MainQuest as aaafortmainquestscript).setWaterWell = True ; #DEBUG_LINE_NO:49
  Self.RegisterForSingleUpdate(10 as Float) ; #DEBUG_LINE_NO:50
EndEvent

Event OnUpdate()
  If TutorialQuest.GetStage() == 20 && !hasBoundaries ; #DEBUG_LINE_NO:54
    TutorialQuest.SetObjectiveCompleted(10, True) ; #DEBUG_LINE_NO:55
    TutorialQuest.SetObjectiveDisplayed(20, True, False) ; #DEBUG_LINE_NO:56
    Game.GetPlayer().AddItem(BoundaryMarkerAPlan as Form, 1, False) ; #DEBUG_LINE_NO:57
    Game.GetPlayer().AddItem(BoundaryMarkerBPlan as Form, 1, False) ; #DEBUG_LINE_NO:58
    Game.GetPlayer().AddItem(BoundaryMarkerCPlan as Form, 1, False) ; #DEBUG_LINE_NO:59
    Game.GetPlayer().AddItem(BoundaryMarkerDPlan as Form, 1, False) ; #DEBUG_LINE_NO:60
    BoundaryMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:61
    (MainQuest as aaafortmainquestscript).setBoundaries = True ; #DEBUG_LINE_NO:62
    hasBoundaries = True ; #DEBUG_LINE_NO:63
  EndIf
  If TutorialQuest.GetStage() == 20 && hasBoundaries && (MainQuest as aaafortmainquestscript).stage == 0 && Game.GetPlayer().GetItemCount(BoundaryMarkerAPlan as Form) == 0 && Game.GetPlayer().GetItemCount(BoundaryMarkerBPlan as Form) == 0 && Game.GetPlayer().GetItemCount(BoundaryMarkerCPlan as Form) == 0 && Game.GetPlayer().GetItemCount(BoundaryMarkerDPlan as Form) == 0 ; #DEBUG_LINE_NO:66
    (MainQuest as aaafortmainquestscript).setBoundaries = False ; #DEBUG_LINE_NO:67
    TutorialQuest.SetStage(30) ; #DEBUG_LINE_NO:68
    TutorialQuest.SetObjectiveCompleted(20, True) ; #DEBUG_LINE_NO:69
    TutorialQuest.SetObjectiveDisplayed(30, True, False) ; #DEBUG_LINE_NO:70
    HouseMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:71
    Game.GetPlayer().AddItem(PlayerHousePlan as Form, 1, False) ; #DEBUG_LINE_NO:72
  EndIf
  If TutorialQuest.GetStage() == 30 && (MainQuest as aaafortmainquestscript).stage == 0 && Game.GetPlayer().GetItemCount(PlayerHousePlan as Form) == 0 ; #DEBUG_LINE_NO:75
    TutorialQuest.SetStage(40) ; #DEBUG_LINE_NO:76
    TutorialQuest.SetObjectiveCompleted(30, True) ; #DEBUG_LINE_NO:77
    TutorialQuest.SetObjectiveDisplayed(40, True, False) ; #DEBUG_LINE_NO:78
    DoorMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:79
    Game.GetPlayer().AddItem(PlayerHouseDoorPlan as Form, 1, False) ; #DEBUG_LINE_NO:80
  EndIf
  If TutorialQuest.GetStage() == 40 && (MainQuest as aaafortmainquestscript).stage == 0 && Game.GetPlayer().GetItemCount(PlayerHouseDoorPlan as Form) == 0 ; #DEBUG_LINE_NO:83
    TutorialQuest.SetStage(50) ; #DEBUG_LINE_NO:84
    TutorialQuest.SetObjectiveCompleted(40, True) ; #DEBUG_LINE_NO:85
    TutorialQuest.SetObjectiveDisplayed(50, True, False) ; #DEBUG_LINE_NO:86
    BarracksMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:87
    Game.GetPlayer().AddItem(BarracksPlan as Form, 1, False) ; #DEBUG_LINE_NO:88
  EndIf
  If (MainQuest as aaafortmainquestscript).GuardCount > 0 && !guardDialog ; #DEBUG_LINE_NO:91
    FirstGuardDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:92
    guardDialog = True ; #DEBUG_LINE_NO:93
  EndIf
  If TutorialQuest.GetStage() == 50 && (MainQuest as aaafortmainquestscript).stage == 0 && guardDialog && Game.GetPlayer().GetItemCount(BarracksPlan as Form) == 0 ; #DEBUG_LINE_NO:96
    TutorialQuest.SetStage(60) ; #DEBUG_LINE_NO:97
    TutorialQuest.SetObjectiveCompleted(50, True) ; #DEBUG_LINE_NO:98
    TutorialQuest.SetObjectiveDisplayed(60, True, False) ; #DEBUG_LINE_NO:99
    MarketMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:100
    Game.GetPlayer().AddItem(MarketPlan as Form, 1, False) ; #DEBUG_LINE_NO:101
  EndIf
  If TutorialQuest.GetStage() == 60 && (MainQuest as aaafortmainquestscript).stage == 0 && Game.GetPlayer().GetItemCount(MarketPlan as Form) == 0 ; #DEBUG_LINE_NO:104
    TutorialQuest.SetStage(70) ; #DEBUG_LINE_NO:105
    TutorialQuest.SetObjectiveCompleted(60, True) ; #DEBUG_LINE_NO:106
    TutorialQuest.SetObjectiveDisplayed(70, True, False) ; #DEBUG_LINE_NO:107
    Game.GetPlayer().AddItem(OutpostMenuItem as Form, 1, False) ; #DEBUG_LINE_NO:108
    PlayerMenuMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:109
    firstRaid = True ; #DEBUG_LINE_NO:110
  EndIf
  If TutorialQuest.GetStage() == 70 && !TutorialQuest.IsCompleted() && (MainQuest as aaafortmainquestscript).stage == 0 && !(PlayerQuest as aaafortplayerquestscript).isRaid && !firstRaid ; #DEBUG_LINE_NO:113
    TutorialQuest.SetObjectiveCompleted(70, True) ; #DEBUG_LINE_NO:114
    TutorialComplete.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:115
    If !RandomQuest.IsRunning() ; #DEBUG_LINE_NO:116
      RandomQuest.Start() ; #DEBUG_LINE_NO:117
    EndIf
    (RandomQuest as aaafortrandomquestscript).RandomRaidEnabled = True ; #DEBUG_LINE_NO:119
    TutorialQuest.CompleteQuest() ; #DEBUG_LINE_NO:120
  EndIf
  If TutorialQuest.IsCompleted() ; #DEBUG_LINE_NO:123
    Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:124
    TutorialQuest.Stop() ; #DEBUG_LINE_NO:125
  Else
    Self.RegisterForSingleUpdate(10 as Float) ; #DEBUG_LINE_NO:127
  EndIf
EndEvent
