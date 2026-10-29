;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortDragonPerchScript.psc
Modified : 2017-12-31 06:09:03
Compiled : 2017-12-31 06:09:04
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortDragonPerchScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ObjectReference Property Dragon Auto
ActorBase Property DragonBase Auto
Int Property DragonCost = 3000 Auto
Message Property DragonDialog Auto
MiscObject Property Gold Auto
Quest Property MainQuest Auto
Message Property NoTamedDragon Auto
Message Property NotEnoughGold Auto
Message Property OneTamedDragon Auto
ObjectReference Property SpawnPoint Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If Game.GetPlayer() as ObjectReference == akActivator ; #DEBUG_LINE_NO:16
    Self.Perch() ; #DEBUG_LINE_NO:17
  EndIf
EndEvent

Function Perch()
  Int result = DragonDialog.Show(DragonCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:22
  If result == 0 ; #DEBUG_LINE_NO:23
    If Dragon == None || (Dragon as Actor).IsDead() ; #DEBUG_LINE_NO:24
      If Game.GetPlayer().GetItemCount(Gold as Form) >= DragonCost ; #DEBUG_LINE_NO:25
        Game.GetPlayer().RemoveItem(Gold as Form, DragonCost, False, None) ; #DEBUG_LINE_NO:26
        Dragon = SpawnPoint.PlaceAtMe(DragonBase as Form, 1, False, False) ; #DEBUG_LINE_NO:27
        Dragon.MoveTo(Dragon, 0 as Float, 0 as Float, 500 as Float, True) ; #DEBUG_LINE_NO:28
      Else
        NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:30
      EndIf
    Else
      OneTamedDragon.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:33
    EndIf
  ElseIf result == 1 ; #DEBUG_LINE_NO:35
    If Dragon != None && !(Dragon as Actor).IsDead() ; #DEBUG_LINE_NO:36
      Dragon.MoveTo(SpawnPoint, 0 as Float, 0 as Float, 500 as Float, True) ; #DEBUG_LINE_NO:37
    Else
      NoTamedDragon.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:39
    EndIf
  EndIf
EndFunction
