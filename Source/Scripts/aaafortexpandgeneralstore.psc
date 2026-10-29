;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortExpandGeneralStore.psc
Modified : 2012-09-09 17:33:47
Compiled : 2017-12-29 05:44:45
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortExpandGeneralStore Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property Expansion Auto
Potion Property GeneralStoreDoor Auto
MiscObject Property Gold001 Auto
ObjectReference Property Sareio Auto
ObjectReference Property StoreMarkerRef Auto
ObjectReference Property WaterWell Auto
ObjectReference Property collisionRef Auto
ObjectReference Property constructionBlock Auto
Int Property cost = 1500 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If (akActivator == Game.GetPlayer() as ObjectReference) && (WaterWell as aaafortwaterwellscript).hasGeneralStore && Game.GetPlayer().GetItemCount(GeneralStoreDoor as Form) < 1 && !Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:15
    Int result = Expansion.Show(cost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:16
    If result == 0 ; #DEBUG_LINE_NO:17
      If Game.GetPlayer().GetItemCount(Gold001 as Form) >= cost ; #DEBUG_LINE_NO:18
        Game.GetPlayer().RemoveItem(Gold001 as Form, cost, False, None) ; #DEBUG_LINE_NO:19
        constructionBlock.Delete() ; #DEBUG_LINE_NO:20
        Sareio.MoveTo(StoreMarkerRef, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:21
        If collisionRef != None ; #DEBUG_LINE_NO:22
          collisionRef.Delete() ; #DEBUG_LINE_NO:23
        EndIf
        Self.Delete() ; #DEBUG_LINE_NO:25
      EndIf
    EndIf
  EndIf
EndEvent
