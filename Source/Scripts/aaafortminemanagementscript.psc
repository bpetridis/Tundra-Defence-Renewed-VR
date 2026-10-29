;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMineManagementScript.psc
Modified : 2012-09-08 12:53:09
Compiled : 2017-12-29 05:44:59
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMineManagementScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property Dialog Auto
MiscObject Property Gold001 Auto
Quest Property MainQuest Auto
ActorBase Property Miner Auto
Int Property MinerCost = 400 Auto
Message Property NotEnoughGold Auto
ObjectReference Property SpawnPoint Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If akActivator == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:12
    Int result = Dialog.Show((MainQuest as aaafortmainquestscript).MinerCount as Float, MinerCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:13
    If result == 0 ; #DEBUG_LINE_NO:14
      If Game.GetPlayer().GetItemCount(Gold001 as Form) >= MinerCost ; #DEBUG_LINE_NO:15
        Game.GetPlayer().RemoveItem(Gold001 as Form, MinerCost, False, None) ; #DEBUG_LINE_NO:16
        SpawnPoint.PlaceAtMe(Miner as Form, 1, False, False) ; #DEBUG_LINE_NO:17
        (MainQuest as aaafortmainquestscript).MinerCount = (MainQuest as aaafortmainquestscript).MinerCount + 1 ; #DEBUG_LINE_NO:18
      Else
        NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:20
      EndIf
    EndIf
  EndIf
EndEvent
