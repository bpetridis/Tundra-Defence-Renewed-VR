;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortDwarvenMachineryScript.psc
Modified : 2012-09-08 18:16:15
Compiled : 2017-12-29 05:44:44
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortDwarvenMachineryScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property Dialog Auto
ActorBase Property DwarvenCenturion Auto
Int Property DwarvenCenturionCost = 3000 Auto
ActorBase Property DwarvenSphere Auto
Int Property DwarvenSphereCost = 2000 Auto
ActorBase Property DwarvenSpider Auto
Int Property DwarvenSpiderCost = 1000 Auto
MiscObject Property Gold001 Auto
Quest Property MainQuest Auto
Message Property NotEnoughGold Auto
ObjectReference Property SpawnPoint Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If akActivator == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:18
    Self.Machinery() ; #DEBUG_LINE_NO:19
  EndIf
EndEvent

Function Machinery()
  Int result = Dialog.Show(DwarvenSpiderCost as Float, DwarvenSphereCost as Float, DwarvenCenturionCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:24
  If result == 0 ; #DEBUG_LINE_NO:25
    If Game.GetPlayer().GetItemCount(Gold001 as Form) >= DwarvenSpiderCost ; #DEBUG_LINE_NO:26
      Game.GetPlayer().RemoveItem(Gold001 as Form, DwarvenSpiderCost, False, None) ; #DEBUG_LINE_NO:27
      SpawnPoint.PlaceAtMe(DwarvenSpider as Form, 1, False, False) ; #DEBUG_LINE_NO:28
      (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:29
      Self.Machinery() ; #DEBUG_LINE_NO:30
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:32
    EndIf
  ElseIf result == 1 ; #DEBUG_LINE_NO:34
    If Game.GetPlayer().GetItemCount(Gold001 as Form) >= DwarvenSphereCost ; #DEBUG_LINE_NO:35
      Game.GetPlayer().RemoveItem(Gold001 as Form, DwarvenSphereCost, False, None) ; #DEBUG_LINE_NO:36
      SpawnPoint.PlaceAtMe(DwarvenSphere as Form, 1, False, False) ; #DEBUG_LINE_NO:37
      (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:38
      Self.Machinery() ; #DEBUG_LINE_NO:39
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:41
    EndIf
  ElseIf result == 2 ; #DEBUG_LINE_NO:43
    If Game.GetPlayer().GetItemCount(Gold001 as Form) >= DwarvenCenturionCost ; #DEBUG_LINE_NO:44
      Game.GetPlayer().RemoveItem(Gold001 as Form, DwarvenCenturionCost, False, None) ; #DEBUG_LINE_NO:45
      SpawnPoint.PlaceAtMe(DwarvenCenturion as Form, 1, False, False) ; #DEBUG_LINE_NO:46
      (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:47
      Self.Machinery() ; #DEBUG_LINE_NO:48
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:50
    EndIf
  EndIf
EndFunction
