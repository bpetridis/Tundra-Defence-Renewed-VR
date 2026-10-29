;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortArcaneTowerScript.psc
Modified : 2012-09-07 11:39:13
Compiled : 2017-12-29 05:44:31
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortArcaneTowerScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ActorBase Property CombatMage Auto
Int Property CombatMageCost = 1500 Auto
ActorBase Property ConjureMage Auto
Int Property ConjureMageCost = 1500 Auto
MiscObject Property Gold Auto
Int Property IllusionMageCost = 1500 Auto
ActorBase Property IllusionistMage Auto
Quest Property MainQuest Auto
Message Property NotEnoughGold Auto
ObjectReference Property SpawnPoint Auto
Message Property TowerDialog Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If (Game.GetPlayer() as ObjectReference == akActivator) && !Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:17
    Self.TowerMenu() ; #DEBUG_LINE_NO:18
  EndIf
EndEvent

Function TowerMenu()
  Int result = TowerDialog.Show(CombatMageCost as Float, ConjureMageCost as Float, IllusionMageCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:23
  If result == 0 ; #DEBUG_LINE_NO:24
    If Game.GetPlayer().GetItemCount(Gold as Form) >= CombatMageCost ; #DEBUG_LINE_NO:25
      Game.GetPlayer().RemoveItem(Gold as Form, CombatMageCost, False, None) ; #DEBUG_LINE_NO:26
      SpawnPoint.PlaceAtMe(CombatMage as Form, 1, False, False) ; #DEBUG_LINE_NO:27
      (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:28
      Self.TowerMenu() ; #DEBUG_LINE_NO:29
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:31
    EndIf
  ElseIf result == 1 ; #DEBUG_LINE_NO:33
    If Game.GetPlayer().GetItemCount(Gold as Form) >= ConjureMageCost ; #DEBUG_LINE_NO:34
      Game.GetPlayer().RemoveItem(Gold as Form, ConjureMageCost, False, None) ; #DEBUG_LINE_NO:35
      SpawnPoint.PlaceAtMe(ConjureMage as Form, 1, False, False) ; #DEBUG_LINE_NO:36
      (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:37
      Self.TowerMenu() ; #DEBUG_LINE_NO:38
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:40
    EndIf
  ElseIf result == 2 ; #DEBUG_LINE_NO:42
    If Game.GetPlayer().GetItemCount(Gold as Form) >= IllusionMageCost ; #DEBUG_LINE_NO:43
      Game.GetPlayer().RemoveItem(Gold as Form, IllusionMageCost, False, None) ; #DEBUG_LINE_NO:44
      SpawnPoint.PlaceAtMe(IllusionistMage as Form, 1, False, False) ; #DEBUG_LINE_NO:45
      (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:46
      Self.TowerMenu() ; #DEBUG_LINE_NO:47
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:49
    EndIf
  EndIf
EndFunction
