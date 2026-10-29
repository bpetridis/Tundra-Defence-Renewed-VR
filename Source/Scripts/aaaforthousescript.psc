;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortHouseScript.psc
Modified : 2012-09-25 15:05:35
Compiled : 2017-12-29 05:44:50
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortHouseScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property CapacityReached Auto
ActorBase Property Citizen Auto
MiscObject Property Gold Auto
Message Property HouseDialog Auto
Quest Property MainQuest Auto
Message Property NotEnoughGold Auto
ObjectReference Property SpawnPoint Auto
Int Property citizenCost = 200 Auto
Int Property currentCitizens = 0 Auto
Int Property indoorCitizens = 0 Auto
Int Property maxCitizens = 3 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If akActivator == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:16
    Int result = HouseDialog.Show(currentCitizens as Float, maxCitizens as Float, indoorCitizens as Float, citizenCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:17
    If result == 0 ; #DEBUG_LINE_NO:18
      If currentCitizens < maxCitizens ; #DEBUG_LINE_NO:19
        If Game.GetPlayer().GetItemCount(Gold as Form) >= citizenCost ; #DEBUG_LINE_NO:20
          Game.GetPlayer().RemoveItem(Gold as Form, citizenCost, False, None) ; #DEBUG_LINE_NO:21
          currentCitizens += 1 ; #DEBUG_LINE_NO:22
          (MainQuest as aaafortmainquestscript).CitizenCount = (MainQuest as aaafortmainquestscript).CitizenCount + 1 ; #DEBUG_LINE_NO:23
          ObjectReference ref = Game.GetPlayer().PlaceAtMe(Citizen as Form, 1, False, False) ; #DEBUG_LINE_NO:24
          Utility.Wait(1 as Float) ; #DEBUG_LINE_NO:25
          (ref as aaafortcitizenscript).House = Self as ObjectReference ; #DEBUG_LINE_NO:26
        Else
          NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:28
        EndIf
      Else
        CapacityReached.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:31
      EndIf
    ElseIf result == 1 ; #DEBUG_LINE_NO:33
      While indoorCitizens > 0 ; #DEBUG_LINE_NO:34
        indoorCitizens -= 1 ; #DEBUG_LINE_NO:35
        ObjectReference ref = Game.GetPlayer().PlaceAtMe(Citizen as Form, 1, False, False) ; #DEBUG_LINE_NO:36
        Utility.Wait(1 as Float) ; #DEBUG_LINE_NO:37
        (ref as aaafortcitizenscript).House = Self as ObjectReference ; #DEBUG_LINE_NO:38
      EndWhile
    EndIf
  EndIf
EndEvent
