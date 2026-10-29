;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortScavengerScript.psc
Modified : 2012-09-25 13:40:19
Compiled : 2017-12-29 05:45:16
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortScavengerScript Extends Actor

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Quest Property MainQuest Auto
ObjectReference Property OutpostTravelMarker Auto
ObjectReference Property ScavengerCrateRef Auto
Message Property ScavengerDialog Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If akActivator == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:10
    Int result = ScavengerDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:11
    If result == 0 ; #DEBUG_LINE_NO:12
      Self.MoveTo(OutpostTravelMarker, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:13
    EndIf
  EndIf
  Actor target = akActivator as Actor ; #DEBUG_LINE_NO:17
  If (target as Bool && target.IsDead()) && (MainQuest as aaafortmainquestscript).ScavengerCount > 0 && (akActivator != Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:19
    If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:20
      target.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:21
      Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:22
      Utility.Wait(5 as Float) ; #DEBUG_LINE_NO:23
      Self.Delete() ; #DEBUG_LINE_NO:24
    EndIf
  EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  Self.RemoveItem(akBaseItem, Self.GetItemCount(akBaseItem), True, ScavengerCrateRef) ; #DEBUG_LINE_NO:30
EndEvent

Event OnDeath(Actor akKiller)
  (MainQuest as aaafortmainquestscript).ScavengerCount = (MainQuest as aaafortmainquestscript).ScavengerCount - 1 ; #DEBUG_LINE_NO:34
  Utility.Wait(30 as Float) ; #DEBUG_LINE_NO:35
  Self.Delete() ; #DEBUG_LINE_NO:36
EndEvent
