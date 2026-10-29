;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortScavengerCrateScript.psc
Modified : 2012-08-26 14:24:28
Compiled : 2017-12-29 05:45:14
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortScavengerCrateScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
MiscObject Property Gold Auto
Quest Property MainQuest Auto
Message Property NotEnoughGold Auto
ActorBase Property Scavenger Auto
Int Property ScavengerCost = 500 Auto
Message Property ScavengerMessage Auto
ObjectReference Property SpawnPoint Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If (akActivator == Game.GetPlayer() as ObjectReference) && !Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:12
    Self.ScavengerMenu() ; #DEBUG_LINE_NO:13
  EndIf
EndEvent

Function ScavengerMenu()
  Int result = ScavengerMessage.Show(ScavengerCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:18
  If result == 0 ; #DEBUG_LINE_NO:19
    If Game.GetPlayer().GetItemCount(Gold as Form) >= ScavengerCost ; #DEBUG_LINE_NO:21
      Game.GetPlayer().RemoveItem(Gold as Form, ScavengerCost, False, None) ; #DEBUG_LINE_NO:22
      SpawnPoint.PlaceAtMe(Scavenger as Form, 1, False, False) ; #DEBUG_LINE_NO:23
      (MainQuest as aaafortmainquestscript).ScavengerCount = (MainQuest as aaafortmainquestscript).ScavengerCount + 1 ; #DEBUG_LINE_NO:24
      Self.ScavengerMenu() ; #DEBUG_LINE_NO:25
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:27
    EndIf
  EndIf
EndFunction
